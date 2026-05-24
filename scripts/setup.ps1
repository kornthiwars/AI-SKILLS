#Requires -Version 5.1
<#
.SYNOPSIS
  One-time setup after cloning AI-SKILLS (Windows).

.DESCRIPTION
  Creates directory junctions for Cursor / Claude Code mirrors and ensures vault folders exist.
  Run from anywhere:  .\scripts\setup.ps1
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $RepoRoot

function Write-Step([string]$Message) {
    Write-Host "=> $Message" -ForegroundColor Cyan
}

function Test-RepoLayout {
    foreach ($dir in @('ai-skills', 'ai-rules', 'templates', 'vault')) {
        if (-not (Test-Path (Join-Path $RepoRoot $dir))) {
            throw "Missing required folder '$dir'. Are you in the AI-SKILLS repo root?"
        }
    }
}

function Get-LinkTarget([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        $target = $item.Target
        if ($target -is [array]) { return $target[0] }
        return $target
    }
    if ($item.LinkType -eq 'SymbolicLink') { return $item.Target }
    return $null
}

function New-DirectoryJunction {
    param(
        [Parameter(Mandatory)][string]$LinkRelative,
        [Parameter(Mandatory)][string]$TargetRelative
    )

    $linkPath = Join-Path $RepoRoot $LinkRelative
    $targetPath = Join-Path $RepoRoot $TargetRelative
  if (-not (Test-Path -LiteralPath $targetPath)) {
        throw "Target does not exist: $TargetRelative"
    }

    $parent = Split-Path -Parent $linkPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $expectedTarget = (Resolve-Path -LiteralPath $targetPath).Path
    $existing = Get-LinkTarget $linkPath
    if ($null -ne $existing) {
        $resolvedExisting = (Resolve-Path -LiteralPath $linkPath).Path
        if ($resolvedExisting -eq $expectedTarget) {
            Write-Host "  OK  $LinkRelative -> $TargetRelative (already linked)"
            return
        }
        Write-Step "Replacing link $LinkRelative"
        Remove-Item -LiteralPath $linkPath -Force -Recurse
    }
    elseif (Test-Path -LiteralPath $linkPath) {
        throw @"
$LinkRelative exists and is not a junction/symlink.
Remove or rename it manually, then re-run scripts/setup.ps1
"@
    }

    # mklink target must be absolute or repo-root-relative from cwd — NOT parent-relative
    # (running inside .cursor with target "ai-skills" wrongly creates .cursor\ai-skills)
    $targetAbs = (Resolve-Path -LiteralPath $targetPath).Path
    $linkAbs = $linkPath
    if (-not (Test-Path -LiteralPath (Split-Path -Parent $linkAbs))) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $linkAbs) -Force | Out-Null
    }
    $mklinkOut = cmd /c mklink /J "$linkAbs" "$targetAbs" 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mklink failed for $LinkRelative (exit $LASTEXITCODE): $mklinkOut`nTry PowerShell as Administrator."
    }
    Write-Host "  OK  $LinkRelative -> $TargetRelative"
}

function Test-MirrorLinks {
    $checks = @(
        @{ Link = '.cursor\skills\upgrade\SKILL.md'; Name = 'Cursor skills' },
        @{ Link = '.cursor\rules\vault-learning.mdc'; Name = 'Cursor rules' },
        @{ Link = '.claude\skills\upgrade\SKILL.md'; Name = 'Claude skills' },
        @{ Link = '.claude\rules\vault-learning.mdc'; Name = 'Claude rules' }
    )
    foreach ($c in $checks) {
        $p = Join-Path $RepoRoot $c.Link
        if (-not (Test-Path -LiteralPath $p)) {
            throw "Verify failed ($($c.Name)): missing $p"
        }
    }
    Write-Host "  OK  all mirror links resolve to canonical files"
}

function Ensure-VaultFolders {
    foreach ($dir in @('vault\issues', 'vault\learnings')) {
        $path = Join-Path $RepoRoot $dir
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Host "  OK  created $dir"
        }
        else {
            Write-Host "  OK  $dir"
        }
    }
}

Write-Host ""
Write-Host "AI-SKILLS setup (Windows)" -ForegroundColor Green
Write-Host "Repo: $RepoRoot"
Write-Host ""

Write-Step "Checking repo layout"
Test-RepoLayout

Write-Step "Creating Cursor / Claude junctions"
New-DirectoryJunction -LinkRelative '.cursor\skills' -TargetRelative 'ai-skills'
New-DirectoryJunction -LinkRelative '.cursor\rules'  -TargetRelative 'ai-rules'
New-DirectoryJunction -LinkRelative '.claude\skills' -TargetRelative 'ai-skills'
New-DirectoryJunction -LinkRelative '.claude\rules'  -TargetRelative 'ai-rules'

Write-Step "Ensuring vault folders"
Ensure-VaultFolders

Write-Step "Verifying links"
Test-MirrorLinks

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Next: open this folder in Cursor, reload the window, then use @ui-builder / @git-push etc."
Write-Host "Obsidian: open repo root as vault (see vault/README.md)."
Write-Host ""
