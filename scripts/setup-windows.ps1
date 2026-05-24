#Requires -Version 5.1
# Junction .cursor/skills and .cursor/rules only. Edit ai-skills/ and ai-rules/ in the repo.
param(
    [Parameter(Mandatory)]
    [string]$InstallRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$InstallRoot = (Resolve-Path -LiteralPath $InstallRoot).Path

$Skills = Join-Path $RepoRoot 'ai-skills'
$Rules = Join-Path $RepoRoot 'ai-rules'

foreach ($dir in @($Skills, $Rules)) {
    if (-not (Test-Path -LiteralPath $dir)) {
        throw "Missing: $dir"
    }
}

function Set-Junction([string]$Link, [string]$Target) {
    $targetAbs = (Resolve-Path -LiteralPath $Target).Path
    $parent = Split-Path -Parent $Link
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    if (Test-Path -LiteralPath $Link) {
        $item = Get-Item -LiteralPath $Link -Force
        if ($item.LinkType -eq 'Junction' -and $item.Target[0] -eq $targetAbs) {
            Write-Host "OK  $Link"
            return
        }
        Remove-Item -LiteralPath $Link -Force -Recurse
    }
    $out = cmd /c mklink /J "`"$Link`"" "`"$targetAbs`"" 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mklink failed: $out`nRun PowerShell as Administrator once."
    }
    Write-Host "OK  $Link -> $targetAbs"
}

Write-Host "Install: $InstallRoot"
Write-Host "Repo:    $RepoRoot"
Write-Host ""

Set-Junction (Join-Path $InstallRoot '.cursor\skills') $Skills
Set-Junction (Join-Path $InstallRoot '.cursor\rules')  $Rules

Write-Host ""
Write-Host "Done. Reload Cursor."
