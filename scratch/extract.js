const fs = require('fs');
const readline = require('readline');

async function processLineByLine() {
  const fileStream = fs.createReadStream('C:\\Users\\rapha\\Downloads\\compilado.txt');

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  const headers = [];
  let lineNumber = 0;
  for await (const line of rl) {
    lineNumber++;
    if (line.startsWith('#')) {
      headers.push(`Line ${lineNumber}: ${line}`);
    }
  }

  fs.writeFileSync('C:\\Users\\rapha\\.gemini\\antigravity-ide\\brain\\b6d4b673-5d76-4f31-be95-6f5004811aa0\\scratch\\headers.txt', headers.join('\n'));
}

processLineByLine();
