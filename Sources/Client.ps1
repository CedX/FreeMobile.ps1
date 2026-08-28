using namespace Belin.FreeMobile
using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation
using namespace System.Net.Http

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

<#
.SYNOPSIS
	Sends an SMS message to the specified Free Mobile account.
.INPUTS
	The message text.
#>
function Send-Message {
	[CmdletBinding(DefaultParameterSetName = "Credential")]
	[OutputType([void])]
	param (
		# The message text.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[string] $Message,

		# The Free Mobile client to use.
		[Parameter(Mandatory, ParameterSetName = "Client")]
		[Client] $Client,

		# The Free Mobile user name and password.
		[Parameter(Mandatory, ParameterSetName = "Credential")]
		[Credential()]
		[pscredential] $Credential,

		# The base URL of the remote API endpoint.
		[Parameter(ParameterSetName = "Credential")]
		[ValidateNotNull()]
		[uri] $Uri = "https://smsapi.free-mobile.fr/"
	)

	begin {
		if (-not $Client) { $Client = New-Client $Credential -Uri $Uri }
	}

	process {
		try { $Client.SendMessage($Message) }
		catch [HttpRequestException] { Write-Error $_ }
	}
}
