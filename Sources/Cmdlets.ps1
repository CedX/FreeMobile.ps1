using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation
using namespace System.Net.Http
using module ./Client.psm1

<#
.SYNOPSIS
	Creates a new Free Mobile client.
.INPUTS
	The Free Mobile user name and password.
.OUTPUTS
	The newly created client.
#>
function New-FreeMobileClient {
	[CmdletBinding()]
	[OutputType([Client])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The Free Mobile user name and password.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[Credential()]
		[pscredential] $Credential,

		# The base URL of the remote API endpoint.
		[uri] $Uri = "https://smsapi.free-mobile.fr/"
	)

	process {
		[Client]::new($Credential, $Uri)
	}
}

<#
.SYNOPSIS
	Sends an SMS message to the specified Free Mobile account.
.INPUTS
	The message text.
#>
function Send-FreeMobileMessage {
	[CmdletBinding(DefaultParameterSetName = "Credential")]
	[OutputType([void])]
	param (
		# The message text.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
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
		[uri] $Uri = "https://smsapi.free-mobile.fr/"
	)

	begin {
		if (-not $Client) { $Client = New-FreeMobileClient $Credential -Uri $Uri }
	}

	process {
		try { $Client.SendMessage($Message) }
		catch [HttpRequestException] { Write-Error $_.Exception }
	}
}
