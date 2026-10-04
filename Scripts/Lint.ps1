using module PSScriptAnalyzer
using module ./Cmdlets.psm1

"Performing the static analysis of source code..."
Invoke-FSharpLint FreeMobile.slnx -Configuration Configuration/FSharpLint.json
$PSScriptRoot, "Tests" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest FreeMobile.psd1 | Out-Null
