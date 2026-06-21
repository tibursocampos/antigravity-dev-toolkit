#Requires -Version 5.1
param([string] $SkillsRoot)

if (-not $SkillsRoot) {
    $scriptDir = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptDir)) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    $SkillsRoot = Join-Path (Split-Path -Parent $scriptDir) 'plugin\skills'
}

Get-ChildItem -LiteralPath $SkillsRoot -Recurse -Filter '*.md' | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    $normalized = $text
    $normalized = $normalized.Replace([string][char]0x2014, '-')
    $normalized = $normalized.Replace([string][char]0x2013, '-')
    $normalized = $normalized.Replace([string][char]0x2192, '->')
    $normalized = $normalized -replace '\*\*STOP\*\* [^\s]+ ask', '**STOP** - ask'
    $normalized = $normalized -replace '\*\*STOP\*\* session [^\s]+ handoff', '**STOP** session - handoff'
    $normalized = $normalized -replace '^[^\r\n]+ If any unchecked: STOP', '-> If any unchecked: STOP'
    $normalized = $normalized -replace 'Step -1 [^\r\n]+ Gate check', 'Step -1 - Gate check'
    if ($normalized -ne $text) {
        [System.IO.File]::WriteAllText($_.FullName, $normalized, [System.Text.UTF8Encoding]::new($false))
        Write-Host "Fixed: $($_.Name)"
    }
}
