<#
.SYNOPSIS
	Sends an SMS notification.
#>
using module Belin.FreeMobile

$credential = [pscredential]::new("Your account identifier", (ConvertTo-SecureString "Your API key" -AsPlainText))
Send-FreeMobileMessage "Hello World from PowerShell!" -Credential $credential
Write-Output "The message was sent successfully."
