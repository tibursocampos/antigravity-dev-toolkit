---
name: performance-profile
description: >
  Analyze code and queries for performance bottlenecks, configure micro-benchmarks, compare metrics,
  and optimize execution. Use when the user says "use skill performance-profile", "optimize performance",
  or "/performance-profile".
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** â€” do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD / orchestrate skills only)
[ ] User confirmed current action (sim)
â†’ If any unchecked: STOP
```

---

# Skill: performance-profile

## Trigger

Invoke when the user requests: `use skill performance-profile`, `optimize performance`, `/performance-profile`, or asks to fix query bottlenecks.

**Arguments (optional):**

| Input | Meaning |
|-------|---------|
| Target method / query | Target function, method, or LINQ/SQL query block to optimize |

## Outcome

Documented performance improvements verified by local benchmarking:
1. Identified bottlenecks (SQL/LINQ analysis, loop allocations).
2. Optimization proposal (e.g., eager loading, projection, indexes, caching, memory span allocations).
3. Micro-benchmark results comparing execution speed and memory allocations (before vs. after).

## Lazy-load

| When | Path |
|------|------|
| C# projects | `_shared/dotnet_guidelines/csharp-patterns.md`, `_shared/dotnet_guidelines/string-manipulation.md` |
| JavaScript / TypeScript | `_shared/javascript_guidelines/clean-code-js.md` |
| Python projects | `_shared/python_guidelines/principles.md` |
| Caveman Mode (if active) | `_shared/caveman/CAVEMAN.md` Ã¢â‚¬â€ Full mode |

## Process

### -1. Re-check guardrails and session
Confirm `GUARDRAILS.md` and `SESSION.md` are loaded.
If missing, ask user (pt-BR):

```text
Antes do profiling, confirme:
- GUARDRAILS.md lido
- SESSION.md carregado

Posso seguir? (sim / ajustar / cancelar)
```

### -2. Caveman Mode Check
Check `~/.gemini/antigravity-ide/sdd/preferences.json` and honor active compressions.

### 0. Target Identification
* Locate the target method, database routine, or loop structure.
* Confirm what metrics are critical: Execution Time (ms) or Memory Allocation (MB/GC cycles).

### 1. Static Performance Audit & Workflow Decision
* Analyze the target code for common anti-patterns:
  * Database: N+1 queries (no eager loading), lack of projection (`select new`), missing query limits (`Take`/`limit`), unindexed search fields.
  * Memory: Excessive allocations inside loops, duplicate string concatenations, boxing/unboxing.
* Present the diagnostic report summarizing the bottlenecks.
* Stop and ask the user to choose the workflow execution path for applying and benchmarking these optimizations:
  * **Option A - Direct Developer Skill (`use skill developer`):** For straightforward local optimization and benchmark setup.
  * **Option B - Classic SDD (`use skill sdd_spec` -> `sdd_plan` -> `sdd_develop`):** For complex structural refactorings or query tuning requiring formal specifications (PRD) and a detailed plan (PLAN) in Portuguese.
  * **Option D - Plain Chat Plan:** Establish a simple task list directly in the chat, executing steps one by one without extra file creations.
* **Wait for explicit user choice** before writing code or initializing another workflow.

### 2. Configure Benchmark
* Propose the setup for a benchmark suite:
  * C#: Create a BenchmarkDotNet class under the test project.
  * Python: Write a test script utilizing `timeit` or `cProfile`.
  * TS/JS: Write a benchmark script utilizing Node's `perf_hooks` or `benchmark.js`.
* Wait for confirmation, then write the benchmark script/class.

### 3. Collect Baseline (Before)
* Instruct the user/agent to run the benchmark script and capture the execution outputs:
  * Capture Mean Time, Standard Deviation, and Allocated Bytes.
* Document the baseline metrics.

### 4. Implement & Verify Optimization
* Write the optimized implementation in a separate branch or method variant (e.g. `CalculateOptimized`).
* Run the benchmark again to compare:
  * Verify that optimization achieves measurable improvements (e.g. 20% speedup or lower GC allocation) without regression.
* Present a comparison table:
  | Variant | Mean Time | Allocated Bytes |
  |---------|-----------|-----------------|
  | Baseline | ... | ... |
  | Optimized | ... | ... |

### 5. Apply Final Changes
* Replace the old code with the validated optimized version.
* Run compiler checks and regular test suites to ensure behavior remains identical.

### 6. Handoff
* Offer committing the optimizations:
  ```
  use skill commit
  ```

## Must not
* Perform optimizations without a benchmark validation.
* Introduce breaking changes or bypass domain validation rules to improve speed.
