Remove-Module ULID -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

$Root = Split-Path -Path $PSScriptRoot
$Files = Get-ChildItem -Path @("$Root\Public", "$Root\Private")

Invoke-Pester -CodeCoverage $Files.FullName

$Module = Join-Path -Path $Root -ChildPath "ULID.psm1"
Remove-Module ULID -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Import-Module $Module

New-Ulid
