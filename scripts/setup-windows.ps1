#Requires -Version 5.1
<#
.SYNOPSIS
  One-time setup after cloning AI-SKILLS (Windows).

.DESCRIPTION
  Creates .cursor / .claude junctions so Cursor and Claude Code read skills from this repo.
  Default: links inside the clone only (safe if Cursor opens the repo root).

  Parent / multi-project (AI-SKILLS + web + api): auto-detects parent, or:
    .\scripts\setup-windows.ps1 -WorkspaceRoot C:\path\to\your-workspace
  Repo only: .\scripts\setup-windows.ps1 -RepoOnly
#>
[CmdletBinding()]
param(
    [string]$WorkspaceRoot = '',
    [switch]$RepoOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $RepoRoot

$SkillsCanonical = Join-Path $RepoRoot 'ai-skills'
$RulesCanonical = Join-Path $RepoRoot 'ai-rules'

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

function Get-LinkItem([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    return Get-Item -LiteralPath $Path -Force
}

function Get-LinkTarget([string]$Path) {
    $item = Get-LinkItem $Path
    if ($null -eq $item) { return $null }
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        $target = $item.Target
        if ($target -is [array]) { return $target[0] }
        return $target
    }
    if ($item.LinkType -eq 'SymbolicLink') { return $item.Target }
    return $null
}

function Test-DirectoryJunction([string]$Path) {
    $item = Get-LinkItem $Path
    return ($null -ne $item) -and ($item.LinkType -eq 'Junction')
}

function Normalize-PathCompare([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    return ([IO.Path]::GetFullPath($Path)).TrimEnd('\')
}

function New-DirectoryJunctionToTarget {
    param(
        [Parameter(Mandatory)][string]$LinkPath,
        [Parameter(Mandatory)][string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        throw "Target does not exist: $TargetPath"
    }

    $parent = Split-Path -Parent $LinkPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $expectedTarget = Normalize-PathCompare $TargetPath
    $existingItem = Get-LinkItem $LinkPath
    if ($null -ne $existingItem) {
        $existingTarget = Get-LinkTarget $LinkPath
        $targetOk = $null -ne $existingTarget -and (
            (Normalize-PathCompare $existingTarget) -eq $expectedTarget
        )
        $junctionOk = Test-DirectoryJunction $LinkPath

        if ($targetOk -and $junctionOk) {
            Write-Host "  OK  $LinkPath (junction -> $expectedTarget)"
            return
        }

        if ($targetOk -and -not $junctionOk) {
            Write-Step "Replacing $($existingItem.LinkType) with junction: $LinkPath"
        }
        else {
            Write-Step "Replacing link $LinkPath"
        }
        Remove-Item -LiteralPath $LinkPath -Force -Recurse
    }
    elseif (Test-Path -LiteralPath $LinkPath) {
        throw @"
$LinkPath exists and is not a directory junction.
Remove or rename it manually, then re-run scripts/setup-windows.ps1
"@
    }

    $targetAbs = Normalize-PathCompare $TargetPath
    $linkAbs = $LinkPath
    if (-not (Test-Path -LiteralPath (Split-Path -Parent $linkAbs))) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $linkAbs) -Force | Out-Null
    }
    # Directory junction only (mklink /J) — not symlink (/D) or copy
    $mklinkOut = cmd /c "mklink /J `"$linkAbs`" `"$targetAbs`"" 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "mklink /J failed for $LinkPath (exit $LASTEXITCODE): $mklinkOut`nTry PowerShell as Administrator."
    }
    if (-not (Test-DirectoryJunction $LinkPath)) {
        throw "Created link at $LinkPath is not an NTFS junction. Got: $((Get-LinkItem $LinkPath).LinkType)"
    }
    Write-Host "  OK  junction $LinkPath -> $targetAbs"
}

function Install-ToolMirrors {
    param(
        [Parameter(Mandatory)][string]$InstallRoot,
        [string]$Label = ''
    )

    $prefix = if ($Label) { "[$Label] " } else { '' }
    Write-Step "$prefix$InstallRoot"

    $pairs = @(
        @{ Link = Join-Path $InstallRoot '.cursor\skills'; Target = $SkillsCanonical },
        @{ Link = Join-Path $InstallRoot '.cursor\rules'; Target = $RulesCanonical },
        @{ Link = Join-Path $InstallRoot '.claude\skills'; Target = $SkillsCanonical },
        @{ Link = Join-Path $InstallRoot '.claude\rules'; Target = $RulesCanonical }
    )
    foreach ($pair in $pairs) {
        New-DirectoryJunctionToTarget -LinkPath $pair.Link -TargetPath $pair.Target
    }
}

function Test-MirrorLinks {
    param(
        [Parameter(Mandatory)][string]$InstallRoot,
        [string]$Label = 'workspace'
    )

    $junctions = @(
        @{ Path = Join-Path $InstallRoot '.cursor\skills'; Name = 'Cursor skills' },
        @{ Path = Join-Path $InstallRoot '.cursor\rules'; Name = 'Cursor rules' },
        @{ Path = Join-Path $InstallRoot '.claude\skills'; Name = 'Claude skills' },
        @{ Path = Join-Path $InstallRoot '.claude\rules'; Name = 'Claude rules' }
    )
    foreach ($j in $junctions) {
        if (-not (Test-DirectoryJunction $j.Path)) {
            $type = if (Test-Path -LiteralPath $j.Path) { (Get-LinkItem $j.Path).LinkType } else { 'missing' }
            throw "Verify failed ($Label / $($j.Name)): $($j.Path) must be NTFS junction (got: $type)"
        }
    }

    $checks = @(
        @{ Link = Join-Path $InstallRoot '.cursor\skills\upgrade\SKILL.md'; Name = 'Cursor skills file' },
        @{ Link = Join-Path $InstallRoot '.cursor\rules\vault-learning.mdc'; Name = 'Cursor rules file' },
        @{ Link = Join-Path $InstallRoot '.claude\skills\upgrade\SKILL.md'; Name = 'Claude skills file' },
        @{ Link = Join-Path $InstallRoot '.claude\rules\vault-learning.mdc'; Name = 'Claude rules file' }
    )
    foreach ($c in $checks) {
        if (-not (Test-Path -LiteralPath $c.Link)) {
            throw "Verify failed ($Label / $($c.Name)): missing $($c.Link)"
        }
    }
    Write-Host "  OK  $Label - all mirrors are junctions and resolve"
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

function Initialize-DailyIssueFile {
    $today = Get-Date -Format 'yyyy-MM-dd'
    $issuePath = Join-Path $RepoRoot "vault\issues\$today.md"

    if (Test-Path -LiteralPath $issuePath) {
        Write-Host "  OK  vault/issues/$today.md"
        return
    }

    $templatePath = Join-Path $RepoRoot 'templates\template.issue.md'
    if (Test-Path -LiteralPath $templatePath) {
        $content = Get-Content -LiteralPath $templatePath -Raw -Encoding UTF8
        $content = $content.Replace('{{YYYY-MM-DD}}', $today)
        $content = [regex]::Replace(
            $content,
            '(?ms)\r?\n## \{\{n\}\}\. \{\{title\}\}.*\z',
            ''
        ).TrimEnd() + "`r`n"
    }
    else {
        $content = @"
---
date: $today
tags: [issues]
---

# Issues — $today

<!-- Type: issues. See vault/README.md -->
"@
    }

    [IO.File]::WriteAllText($issuePath, $content, [Text.UTF8Encoding]::new($false))
    Write-Host "  OK  created vault/issues/$today.md (daily issues bootstrap)"
}

function Write-VaultPointer {
    param(
        [Parameter(Mandatory)][string]$InstallRoot
    )

    $pointerDir = Join-Path $InstallRoot '.cursor'
    if (-not (Test-Path -LiteralPath $pointerDir)) {
        New-Item -ItemType Directory -Path $pointerDir -Force | Out-Null
    }

    $vaultRoot = Join-Path $RepoRoot 'vault'
    $json = @{
        repoRoot          = $RepoRoot
        vaultRoot         = $vaultRoot
        issuesRelative    = 'vault/issues'
        learningsRelative = 'vault/learnings'
    } | ConvertTo-Json -Compress

    $pointerPath = Join-Path $pointerDir 'ai-skills-vault.json'
    [IO.File]::WriteAllText($pointerPath, $json, [Text.UTF8Encoding]::new($false))
    Write-Host "  OK  wrote $pointerPath"
}

function Get-MultiProjectParent {
    if ($RepoOnly) { return $null }

    $parent = (Resolve-Path (Join-Path $RepoRoot '..')).Path
    if ($parent -eq $RepoRoot) { return $null }

    foreach ($name in @('web', 'api', 'frontend', 'backend')) {
        if (Test-Path -LiteralPath (Join-Path $parent $name)) {
            return $parent
        }
    }

    $repoNorm = Normalize-PathCompare $RepoRoot
    $siblings = 0
    foreach ($child in Get-ChildItem -LiteralPath $parent -Directory -ErrorAction SilentlyContinue) {
        if ($child.Name.StartsWith('.')) { continue }
        if ((Normalize-PathCompare $child.FullName) -eq $repoNorm) { continue }
        $siblings++
    }
    if ($siblings -ge 1) { return $parent }
    return $null
}

function Test-VaultPointerFile {
    param(
        [Parameter(Mandatory)][string]$InstallRoot,
        [string]$Label = ''
    )

    $pointer = Join-Path $InstallRoot '.cursor\ai-skills-vault.json'
    if (-not (Test-Path -LiteralPath $pointer)) {
        throw "Verify failed ($Label): missing $pointer"
    }
    Write-Host "  OK  $Label ai-skills-vault.json"
}

function Install-VaultMirror {
    param(
        [Parameter(Mandatory)][string]$InstallRoot
    )

    if ((Normalize-PathCompare $InstallRoot) -eq (Normalize-PathCompare $RepoRoot)) {
        return
    }

    $linkPath = Join-Path $InstallRoot 'vault'
    $targetPath = Join-Path $RepoRoot 'vault'
    New-DirectoryJunctionToTarget -LinkPath $linkPath -TargetPath $targetPath
}

function Test-VaultReady {
    param(
        [Parameter(Mandatory)][string]$InstallRoot,
        [string]$Label = 'workspace'
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    $issueRepo = Join-Path $RepoRoot "vault\issues\$today.md"
    if (-not (Test-Path -LiteralPath $issueRepo)) {
        throw "Verify failed ($Label): missing $issueRepo"
    }

    if ((Normalize-PathCompare $InstallRoot) -ne (Normalize-PathCompare $RepoRoot)) {
        $vaultLink = Join-Path $InstallRoot 'vault'
        if (-not (Test-DirectoryJunction $vaultLink)) {
            $type = if (Test-Path -LiteralPath $vaultLink) { (Get-LinkItem $vaultLink).LinkType } else { 'missing' }
            throw "Verify failed ($Label): $vaultLink must be junction to repo vault (got: $type)"
        }
        $issueWs = Join-Path $InstallRoot "vault\issues\$today.md"
        if (-not (Test-Path -LiteralPath $issueWs)) {
            throw "Verify failed ($Label): workspace cannot read $issueWs"
        }
    }

    Write-Host "  OK  $Label vault/issues/$today.md ready"
}

function Get-InstallRoots {
    if ($WorkspaceRoot) {
        $custom = (Resolve-Path -LiteralPath $WorkspaceRoot).Path
        if ($RepoOnly -or $custom -eq $RepoRoot) {
            return [ordered]@{ repo = $RepoRoot }
        }
        return [ordered]@{ workspace = $custom }
    }

    $autoParent = Get-MultiProjectParent
    if ($autoParent) {
        return [ordered]@{ workspace = $autoParent }
    }

    return [ordered]@{ repo = $RepoRoot }
}

function Remove-InRepoMirrors {
    param([hashtable]$CanonicalTargets)

    $linkNames = @(
        '.cursor\skills', '.cursor\rules',
        '.claude\skills', '.claude\rules'
    )
    foreach ($rel in $linkNames) {
        $path = Join-Path $RepoRoot $rel
        if (-not (Test-Path -LiteralPath $path)) { continue }

        if (-not (Test-DirectoryJunction $path)) { continue }

        $target = Get-LinkTarget $path
        if ($null -eq $target) { continue }

        $expected = if ($rel -match 'skills$') { $CanonicalTargets.skills } else { $CanonicalTargets.rules }
        if ((Normalize-PathCompare $target) -eq (Normalize-PathCompare $expected)) {
            Remove-Item -LiteralPath $path -Force -Recurse
            Write-Host "  OK  removed in-repo mirror $rel (use parent workspace links)"
        }
    }
}

Write-Host ""
Write-Host "AI-SKILLS setup-windows (NTFS junctions)" -ForegroundColor Green
Write-Host "Repo: $RepoRoot"
Write-Host ""

Write-Step "Checking repo layout"
Test-RepoLayout

$installRoots = Get-InstallRoots
if ($installRoots.Contains('workspace')) {
    if ($WorkspaceRoot) {
        Write-Host "Cursor workspace (WORKSPACE_ROOT): $($installRoots['workspace'])"
    }
    else {
        Write-Host "Cursor workspace (auto: sibling projects detected): $($installRoots['workspace'])"
    }
    Write-Host "Creating .cursor, .claude, vault junction, ai-skills-vault.json here."
    Write-Host ""
}

Write-Step "Creating Cursor / Claude junctions"
foreach ($entry in $installRoots.GetEnumerator()) {
    Install-ToolMirrors -InstallRoot $entry.Value -Label $entry.Key
}

if ($installRoots.Contains('workspace') -and -not $installRoots.Contains('repo')) {
    Write-Step "Cleaning in-repo mirrors (optional)"
    Remove-InRepoMirrors -CanonicalTargets @{
        skills = $SkillsCanonical
        rules  = $RulesCanonical
    }
}

Write-Step "Ensuring vault (folders, daily issues, workspace link)"
Ensure-VaultFolders
Initialize-DailyIssueFile
if ($installRoots.Contains('workspace')) {
    Install-VaultMirror -InstallRoot $installRoots['workspace']
}

Write-VaultPointer -InstallRoot $RepoRoot
if ($installRoots.Contains('workspace')) {
    Write-VaultPointer -InstallRoot $installRoots['workspace']
}

Write-Step "Verifying links"
foreach ($entry in $installRoots.GetEnumerator()) {
    Test-MirrorLinks -InstallRoot $entry.Value -Label $entry.Key
    Test-VaultReady -InstallRoot $entry.Value -Label $entry.Key
}
Test-VaultPointerFile -InstallRoot $RepoRoot -Label 'repo'
if ($installRoots.Contains('workspace')) {
    Test-VaultPointerFile -InstallRoot $installRoots['workspace'] -Label 'workspace'
}

$openFolder = ($installRoots.Values | Select-Object -First 1)
Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Open in Cursor: $openFolder"
Write-Host "Then reload the window and try @ui-builder / @git-push."
Write-Host "Obsidian: open repo root ($RepoRoot) as vault - see vault/README.md."
Write-Host ""
