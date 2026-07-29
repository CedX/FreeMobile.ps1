using namespace Belin.FreeMobile
using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation

<#
.SYNOPSIS
	The module version.
#>
[semver] $Script:Version = & {
	$path = "$PSScriptRoot/../Belin.FreeMobile.psd1"
	(Import-PowerShellDataFile ((Test-Path $path) ? $path : "$PSScriptRoot/../FreeMobile.psd1")).ModuleVersion
}

<#
.SYNOPSIS
	Creates a new Free Mobile client.
.INPUTS
	The Free Mobile user name and password.
.OUTPUTS
	The newly created client.
#>
function New-Client {
	[CmdletBinding()]
	[OutputType([Belin.FreeMobile.Client])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The Free Mobile user name and password.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Credential()]
		[pscredential] $Credential,

		# The user agent string to use when making requests.
		[ValidateNotNullOrWhiteSpace()]
		[string] $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) | Belin.FreeMobile/$Script:Version",

		# The base URL of the remote API endpoint.
		[ValidateNotNull()]
		[uri] $Uri = "https://smsapi.free-mobile.fr/"
	)

	process {
		$client = [Client]::new($Credential)
		$client.BaseUrl = $Uri
		$client.UserAgent = $UserAgent
		$client
	}
}
