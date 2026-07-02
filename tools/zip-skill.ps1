#!/usr/bin/env pwsh
# Build the uploadable skill zip for claude.ai / Claude Desktop into dist/.
# PowerShell script - run as ./tools/zip-skill.ps1 (Windows PowerShell 5+ or PowerShell 7+).
$ErrorActionPreference = 'Stop'

# Move to the repo root (parent of this script's directory).
Set-Location (Join-Path $PSScriptRoot '..')

$dist = 'dist'
$zip = Join-Path $dist 'prompt-optimizer-skill.zip'

New-Item -ItemType Directory -Force -Path $dist | Out-Null
if (Test-Path $zip) { Remove-Item $zip -Force }

$skillsRoot = 'plugins/prompt-optimizer/skills'
$source = Join-Path $skillsRoot 'prompt-optimizer'

# Collect files, excluding .DS_Store, and add them to the archive with paths
# relative to the skills root so the zip contains a top-level prompt-optimizer/.
$files = Get-ChildItem -Path $source -Recurse -File |
  Where-Object { $_.Name -ne '.DS_Store' }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$fullSkillsRoot = (Resolve-Path $skillsRoot).Path
$archive = [System.IO.Compression.ZipFile]::Open((Join-Path (Get-Location) $zip), 'Create')
try {
  foreach ($file in $files) {
    $entryName = [System.IO.Path]::GetRelativePath($fullSkillsRoot, $file.FullName).Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName) | Out-Null
  }
} finally {
  $archive.Dispose()
}

Write-Host "Built $zip"
Write-Host 'Upload via claude.ai > Settings > Capabilities > Skills.'
