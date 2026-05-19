using module PSScriptAnalyzer

"Performing the static analysis of source code..."
$PSScriptRoot, "Sources", "Tests" | Invoke-ScriptAnalyzer -ExcludeRule PSAvoidUsingConvertToSecureStringWithPlainText -Recurse
Test-ModuleManifest FreeMobile.psd1 | Out-Null
