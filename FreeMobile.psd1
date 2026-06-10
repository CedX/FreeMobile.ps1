@{
	DefaultCommandPrefix = "FreeMobile"
	ModuleVersion = "1.1.0"
	PowerShellVersion = "7.6"
	RootModule = "Sources/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Send SMS messages to your Free Mobile device."
	GUID = "8a16d600-a064-4037-9147-d13059c6abf7"

	AliasesToExport = @()
	CmdletsToExport = @()
	RequiredAssemblies = , "Binaries/Belin.FreeMobile.dll"
	VariablesToExport = @()

	FunctionsToExport = @(
		"New-Client"
		"Send-Message"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/CedX/FreeMobile.ps1/blob/main/License.md"
			ProjectUri = "https://github.com/CedX/FreeMobile.ps1"
			ReleaseNotes = "https://github.com/CedX/FreeMobile.ps1/releases"
			Tags = "api", "client", "free", "mobile", "sms"
		}
	}
}
