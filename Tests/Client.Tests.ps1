using module ../FreeMobile.psd1

<#
.SYNOPSIS
	Tests the features of the `Send-Message` cmdlet.
#>
Describe "Send-Message" {
	It "should throw an exception if a network error occurred" {
		$credential = [pscredential]::new("anonymous", (ConvertTo-SecureString "secret" -AsPlainText))
		Should-Throw -ScriptBlock { "Hello World!" | Send-FreeMobileMessage -Credential $credential -Uri "http://localhost:666" -ErrorAction Stop }
	}

	It "should throw an exception if the credentials are invalid" {
		$credential = [pscredential]::new("anonymous", (ConvertTo-SecureString "secret" -AsPlainText))
		Should-Throw -ScriptBlock { "Hello World!" | Send-FreeMobileMessage -Credential $credential -ErrorAction Stop }
	}

	It "should send SMS messages if the credentials are valid" {
		$credential = [pscredential]::new($Env:FREEMOBILE_ACCOUNT, (ConvertTo-SecureString $Env:FREEMOBILE_API_KEY -AsPlainText))
		& { "Hello Cédric, from PowerShell!" | Send-FreeMobileMessage -Credential $credential -ErrorAction Stop } | Out-Null
	}
}
