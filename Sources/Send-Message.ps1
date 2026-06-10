using namespace Belin.FreeMobile
using namespace System.Net.Http

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
		if (-not $Client) { $Client = New-Client $Credential -Uri $Uri }
	}

	process {
		try { $Client.SendMessage($Message) }
		catch [HttpRequestException] { Write-Error $_ }
	}
}
