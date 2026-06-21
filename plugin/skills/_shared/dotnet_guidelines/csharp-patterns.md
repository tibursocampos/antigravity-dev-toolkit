# C# Best Practices and .NET Test Patterns

> **Highest priority.** When this document conflicts with generic best practices, **always follow this document**.

---

## C# best practices

### File structure (required - blocking in review)

**One top-level type per `.cs` file** (PRD CA1, RN01). Applies to every new or moved type: `class`, `record`, `sealed class`, `static class`, `struct`, `enum`, and equivalent top-level declarations.

| Rule | Detail |
|------|--------|
| **One file, one top-level type** | Each type lives in its own file |
| **File name** | Match the primary type name (e.g. `OrderService.cs` -> `OrderService`) |
| **Forbidden** | Two or more top-level types in the same file |
| **Review** | **Blocking** - reject the PR until types are split into separate files |

**Allowed exception:** `private` nested types inside the owning top-level type when they are implementation details of that type only (not shared across files).

```csharp
// Wrong - two top-level types in OrderHandlers.cs
public sealed class RegisterOrderHandler { /* ... */ }
public sealed class CancelOrderHandler { /* ... */ }

// Correct - one type per file
// RegisterOrderHandler.cs
public sealed class RegisterOrderHandler { /* ... */ }

// CancelOrderHandler.cs
public sealed class CancelOrderHandler { /* ... */ }

// Correct - private nested type as implementation detail
public sealed class OrderPricingService
{
    private sealed class LineItemAccumulator
    {
        public decimal Total { get; private set; }
    }
}
```

### Method signatures and invocations (required - blocking in review)

**Same formatting rules for method declarations and method invocations.**

| Condition | Format |
|-----------|--------|
| **Inline (single line)** | Up to **4** parameters **and** the full declaration or invocation line is **≤ 180 characters** |
| **Multiline (required)** | **5 or more** parameters **or** the full line **exceeds 180 characters** -> **one parameter per line** |
| **Review** | **Blocking** - request reformat before merge |

**Character count:** Count the **entire physical line** of the signature or invocation (from the start of the return type / access modifier through the closing `)` and `;` or `{`).

```csharp
// Correct - inline (4 parameters, line ≤ 180)
public async Task<ImageStorageUploadResult> UploadGeneratedImageAsync(ImageStorageUploadRequest request, CancellationToken cancellationToken = default)

// Correct - inline invocation
var order = await _orderRepository.GetByIdAsync(id, cancellationToken);

// Required - multiline (5+ parameters)
public async Task<OrderSummary> BuildOrderSummaryAsync(
    int orderId,
    string customerCode,
    DateTime fromDate,
    DateTime toDate,
    bool includeCancelled,
    CancellationToken cancellationToken = default)

// Required - multiline invocation (same rule)
await _notificationService.SendOrderStatusChangedAsync(
    order.Id,
    order.CustomerId,
    previousStatus,
    order.Status,
    correlationId,
    cancellationToken);

// Wrong - unnecessary break when inline rule applies
public async Task<Order?> GetByIdAsync(
    int id,
    CancellationToken cancellationToken = default)
```

### Follow existing project patterns (required - blocking in review)

Before adding types, handlers, validators, or helpers, **discover how the repository already solves the same problem**. Use **Glob** and **Read** on similar files (same layer, feature folder, naming suffix). Match folder layout, namespaces, DI registration, and class flow.

| Rule | Detail |
|------|--------|
| **Discover first** | Find existing `*Handler`, `*Validator`, `*Repository`, controllers, and feature folders before inventing a new shape |
| **Reuse consolidated patterns** | If the project uses FluentValidation, CQRS handlers, repository interfaces, etc., extend that pattern |
| **Forbidden** | Parallel flows when a consolidated approach already exists |
| **Class flow** | Reuse existing `private` methods in the same class before duplicating logic |
| **Review** | **Blocking** - reject PRs that introduce a second way to do what the codebase already standardizes |

```csharp
// Wrong - manual validation in handler when project uses FluentValidation
public async Task<Result> Handle(RegisterOrderCommand command, CancellationToken cancellationToken)
{
    if (string.IsNullOrWhiteSpace(command.OrderNumber))
        return Result.Error("Order number is required");
    // ...
}

// Correct - validator owns rules; handler orchestrates
public class RegisterOrderCommandValidator : AbstractValidator<RegisterOrderCommand>
{
    public RegisterOrderCommandValidator()
    {
        RuleFor(c => c.OrderNumber).NotEmpty();
    }
}
```

### Named constants (no magic literals) (required - blocking in review)

Every **string and number** in **production code** must be a **named constant** with a clear English identifier. Applies to error messages, log messages, FluentValidation rules, configuration keys, HTTP status codes, query keys, templates, and exception text.

| Rule | Detail |
|------|--------|
| **No magic literals** | No raw `"..."` or numeric literals with semantic meaning in production paths |
| **Naming** | **PascalCase** for all `const` identifiers. **Forbidden:** `UPPER_SNAKE_CASE` |
| **Reuse first** | Grep/search project `Constants`, message types, and domain files before adding a new constant |
| **Location** | `private const` in the owning class when used in one file only; public shared type when reused across classes |
| **No duplication** | Do not copy the same literal into multiple classes or constant files |
| **Review** | **Blocking** - request extraction before merge |

**Allowed exception:** In an arithmetic expression, a **numeric multiplier factor** may stay inline when it is the only literal in that expression (e.g. unit conversion `bytes * 1024`).

```csharp
// Wrong - magic strings and numbers in production
_logger.LogWarning("Order {Id} not found", orderId);
return Result.NotFound("Order not found");
RuleFor(x => x.Quantity).LessThan(0).WithMessage("Quantity must be non-negative");

// Correct - named constants (PascalCase)
private const string OrderNotFoundLogTemplate = "Order {OrderId} not found";
private const string OrderNotFoundMessage = "Order not found";
private const int MinimumQuantity = 0;

_logger.LogWarning(OrderNotFoundLogTemplate, orderId);
return Result.NotFound(OrderNotFoundMessage);
RuleFor(x => x.Quantity).GreaterThanOrEqualTo(MinimumQuantity);

// Wrong - UPPER_SNAKE_CASE
public const string DEFAULT_ORDER_NUMBER = "ORD-001";

// Correct
public const string DefaultOrderNumber = "ORD-001";
```

### Method ordering within classes (required - blocking in review)

| Rule | Detail |
|------|--------|
| **Visibility blocks** | All **public** methods before all **private** methods |
| **Alphabetical order** | Within the public block and within the private block, order methods **alphabetically by method name** |
| **New or moved methods** | Insert at the correct position in the block |
| **Review** | **Blocking** - request reorder before merge |

```csharp
// Wrong - private before public; methods out of alphabetical order
public sealed class OrderService
{
    private void ValidateOrder(Order order) { }

    public async Task<Order?> GetByIdAsync(int id, CancellationToken cancellationToken = default) { }

    public async Task RegisterAsync(RegisterOrderCommand command, CancellationToken cancellationToken = default) { }

    private decimal CalculateTotal(Order order) { }
}

// Correct - public block (alphabetical), then private block (alphabetical)
public sealed class OrderService
{
    public async Task<Order?> GetByIdAsync(int id, CancellationToken cancellationToken = default) { }

    public async Task RegisterAsync(RegisterOrderCommand command, CancellationToken cancellationToken = default) { }

    private decimal CalculateTotal(Order order) { }

    private void ValidateOrder(Order order) { }
}
```

### Microsoft C# Language Conventions

To ensure C# implementations align with official Microsoft guidelines, enforce the following patterns:

#### 1. Language Keywords vs. BCL Runtime Types
* Use language keywords instead of BCL runtime types (e.g., use `string` instead of `System.String`, `int` instead of `System.Int32`, `nint` instead of `System.IntPtr`).
* Prefer `int` over unsigned types (like `uint` or `ulong`) unless strictly required.

#### 2. Type Inference (`var`)
* Use `var` only when the type is obvious from the right-hand side of the assignment (e.g., using `new`, explicit casts, or literals).
* Do **not** use `var` if the type isn't apparent from the right side.
* Use implicit typing (`var`) in `for` loops and LINQ query sequences, but use explicit types in `foreach` loops to prevent accidental type casting or execution context shifts (like query execution).

#### 3. String Data
* Use **string interpolation** (`$""`) for concatenating short strings.
* Use `System.Text.StringBuilder` for concatenating strings in loops or large text operations.
* Prefer **raw string literals** (`"""..."""`) over escape sequences or verbatim strings for multiline text blocks.
* Use expression-based string interpolation rather than positional string formatting.

#### 4. Object Instantiation and Initialization
* Use target-typed `new()` expressions when the variable type matches the object type exactly:
  ```csharp
  ExampleClass instance = new();
  ```
* Use object initializers (`new ExampleClass { Property = value }`) instead of setting properties line-by-line.
* Use `required` properties instead of complex constructors to enforce initialization of property values.

#### 5. Arrays and Collections
* Use **collection expressions** (`[...]`) to initialize all collection types:
  ```csharp
  string[] vowels = [ "a", "e", "i", "o", "u" ];
  List<int> numbers = [ 1, 2, 3 ];
  ```

#### 6. Exception Handling & Resources
* Catch only exceptions that can be properly handled. Do **not** catch general `System.Exception` without an exception filter.
* Use specific exception types for precise diagnostics.
* Use brace-less `using` statement declarations for resources implementing `IDisposable` or `IAsyncDisposable`:
  ```csharp
  using Font normalStyle = new("Arial", 10.0f);
  ```

#### 7. Namespace & Using Directives
* Use **file-scoped namespace** declarations:
  ```csharp
  namespace MyProject.Features.Orders;
  ```
* Place `using` directives **outside** the namespace declaration to avoid relative namespace resolution conflicts.

#### 8. Delegates & Events
* Use `Func<>` and `Action<>` instead of defining custom delegate types.
* Use lambda expressions for event handlers that do not need to be unregistered.

### Async/await

- Async methods must use the `Async` suffix.
- Always use `await`.
- Do not use `.Result` or `.Wait()`.

```csharp
// Correct
public async Task<Order> GetOrderAsync(int id, CancellationToken cancellationToken = default)
{
    return await _orderRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
}

// Wrong - deadlock risk
public Order GetOrder(int id)
{
    return _orderRepository.GetByIdAsync(id).Result;
}
```

### Nullable reference types

```csharp
// Correct
public string OrderNumber { get; init; } = string.Empty;
public string? Notes { get; init; }
```

### Record types

```csharp
public record OrderDto(int Id, string OrderNumber, DateTime CreatedAt);
public record OrderReference(string Code, string ProductionLine);
```

### Dependency injection

```csharp
public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Order>> GetAllAsync(CancellationToken cancellationToken = default);
}

services.AddScoped<IOrderRepository, OrderRepository>();
services.AddTransient<IValidator<RegisterOrderCommand>, RegisterOrderCommandValidator>();
```

### IOptions pattern

```csharp
public class OrderService
{
    private readonly OrderOptions _options;

    public OrderService(IOptions<OrderOptions> options)
    {
        _options = options.Value;
    }
}

services.Configure<OrderOptions>(configuration.GetSection("Order"));
```

### Resource management

```csharp
await using var connection = new SqlConnection(connectionString);
await connection.OpenAsync(cancellationToken);

public class IntegrationClient
{
    private readonly HttpClient _httpClient;

    public IntegrationClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }
}
```

---

## .NET test patterns

### Required frameworks (new code)

| Framework | Usage |
|-----------|--------|
| **xUnit** / **NUnit** | `[Fact]`/`[Test]`, `[Theory]`/`[TestCase]`, fixtures |
| **Shouldly** | Assertions via `.ShouldBe()`, `.ShouldNotBeNull()`, etc. |
| **Moq** / **NSubstitute** | Mocks/Substitutes for dependencies |
| **Bogus** / **Fake** | Test data generation and entity fakers |
| **WireMock.Net** | HTTP stubbing in integration/infrastructure tests (when needed) |

Prefer **xUnit/NUnit + Moq/NSubstitute + Shouldly** for all new tests.

---

### Test naming (required)

```
Should_<ExpectedResult>_When_<Condition>
```

**Examples:**

- `Should_Register_Order_When_Data_Is_Valid`
- `Should_Return_Error_When_Order_Not_Found`
- `Should_Throw_When_Customer_Is_Inactive`
- `Should_Update_Status_When_Order_Is_Pending`

**Rules:**

- Use English identifiers.
- Do not use `Given_When_Then` naming.
- Avoid extra underscores beyond the pattern.

---

### Test structure and strategy

- **Strategy Priority:** Prefer **Integration Tests** over Unit Tests whenever feasible. Testing the actual flow (DB, API) provides more value. Use Unit Tests primarily for isolated, complex domain logic.
- Structure each test with **Arrange / Act / Assert** - use `// Arrange`, `// Act`, and `// Assert` section comments.
- One test validates **one behavior**.
- No loops or conditional logic inside tests.

```csharp
public class RegisterOrderHandlerTests : IAsyncLifetime
{
    private readonly Mock<IOrderRepository> _orderRepositoryMock = new();
    private IServiceProvider _serviceProvider = null!;

    public async Task InitializeAsync()
    {
        var services = new ServiceCollection();
        services.AddScoped(_ => _orderRepositoryMock.Object);
        services.AddScoped<RegisterOrderHandler>();
        _serviceProvider = services.BuildServiceProvider();
        await Task.CompletedTask;
    }

    public async Task DisposeAsync()
    {
        if (_serviceProvider is IAsyncDisposable asyncDisposable)
            await asyncDisposable.DisposeAsync();
        else if (_serviceProvider is IDisposable disposable)
            disposable.Dispose();
    }

    [Fact]
    public async Task Should_Return_Order_When_Id_Is_Valid()
    {
        // Arrange
        var order = OrderFake.CreateValid();
        _orderRepositoryMock
            .Setup(r => r.GetByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(order);
        var command = OrderFake.CreateValidCommand();

        await using var scope = _serviceProvider.CreateAsyncScope();
        var handler = scope.ServiceProvider.GetRequiredService<RegisterOrderHandler>();

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.Id.Should().Be(order.Id);
    }
}
```

---

### SUT via dependency injection (required)

**Resolve the system under test from the container; do not `new` handlers/services with manual constructor wiring when DI is available.**

```csharp
// Correct
await using var scope = _serviceProvider.CreateAsyncScope();
var handler = scope.ServiceProvider.GetRequiredService<RegisterOrderHandler>();

// Wrong for application services
var handler = new RegisterOrderHandler(_repoMock.Object, _loggerMock.Object);
```

---

### Naming in tests

- Variables, properties, and methods in **English**.
- Mock variables must use the `Mock` suffix.

```csharp
var orderRepositoryMock = new Mock<IOrderRepository>();
```

---

### Fakes and Data Generation (Bogus) (required for arrange data)

**All DTOs, entities, and collections used in arrange belong in reusable static `*Fake` classes.**
Tools like **Bogus** or **Fake** are explicitly permitted and encouraged to optimize test data setup.

- Place fakes under `Fake/` or `Fixtures/` in the test project.
- Reuse named constants in **PascalCase**.
- Factory methods named `Create*` or `Get*` as appropriate.
- Search for existing `*Fake.cs` before adding a new one.

```csharp
public static class OrderFake
{
    public const string DefaultOrderNumber = "ORD-001";

    public static Faker<Order> Valid() => new Faker<Order>()
        .RuleFor(o => o.OrderNumber, f => DefaultOrderNumber)
        .RuleFor(o => o.IsActive, f => true);

    public static Order CreateValid(string orderNumber = DefaultOrderNumber) =>
        Valid().RuleFor(o => o.OrderNumber, orderNumber).Generate();
}
```

---

### Moq usage

```csharp
var orderRepositoryMock = new Mock<IOrderRepository>();

orderRepositoryMock
    .Setup(r => r.GetByIdAsync(It.Is<int>(id => id == OrderFake.DefaultId), It.IsAny<CancellationToken>()))
    .ReturnsAsync(order);

orderRepositoryMock.Verify(
    r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()),
    Times.Once);
```

---

### Shouldly

```csharp
result.ShouldNotBeNull();
result.ShouldBeTrue();
result.ShouldBeFalse();
result.ShouldBeNull();
result.Count.ShouldBe(3);
result.ShouldContain(x => x.Id == expectedId);
Should.Throw<InvalidOperationException>(() => action());

// Avoid classic Assert.That / Assert.Equal for new tests
```

---

### Parameterized tests

```csharp
[Theory]
[InlineData(true)]
[InlineData(false)]
public void Should_Validate_Command(RegisterOrderCommand command, bool expectedValid)
{
    var result = _validator.Validate(command);
    result.IsValid.ShouldBe(expectedValid);
}
```

---

### Deterministic tests

- Do not use `DateTime.Now` directly - inject `TimeProvider` or a clock abstraction.
- Do not use uncontrolled `Guid.NewGuid()` when assertions depend on the value.
- Encapsulate non-determinism in fakes or providers.
- Do not rely on implicit ordering.

---

### Integration tests (Preferred)

Integration tests are prioritized over unit tests. Use `WebApplicationFactory` to test end-to-end flows.

```csharp
public class OrderApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public OrderApiTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task Should_Return_200_When_Order_Exists()
    {
        var response = await _client.GetAsync("/api/orders/1");
        response.StatusCode.ShouldBe(HttpStatusCode.OK);
    }
}
```

---

## Blocking test anti-patterns (review checklist)

Any of the following in new `*Test*.cs` / `*Tests.cs` files should be fixed before merge:

| # | Anti-pattern | Fix |
|---|--------------|-----|
| 1 | Manual `new` on injectable handlers/services | Resolve via `GetRequiredService<T>()` |
| 2 | Full DI rebuild in every test method | Move registration to fixture / `IAsyncLifetime` |
| 3 | Inline `new DomainEntity { ... }` in tests | Move to `*Fake` |
| 4 | Private `Create*` / `Build*` helpers on fixture for domain data | Move to `*Fake` / `Bogus` |
| 5 | Classic `Assert.*` in new tests | Use Shouldly `.ShouldBe()` |
| 6 | Test name not `Should_*_When_*` | Rename |
| 7 | `.Result` / `.Wait()` on tasks | Use `await` |

**Accepted patterns:** `IClassFixture<T>`, `CreateScope()`, `*Fake.*`, `Mock<T>`, `NSubstitute`, `.ShouldBe()`, `[Theory]`, `Should_*_When_*`, `Bogus`.

**Legitimate exceptions:**

- Pure domain entity tests with no DI: `new OrderLine(...)` is fine when the type has no injectable dependencies - still use fakes for complex arrange data.
- `[MemberData]` builders on the test class for xUnit data sources.

Document exceptions in the PR when a rule truly does not apply.
