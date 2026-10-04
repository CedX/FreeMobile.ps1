namespace Belin.FreeMobile

open System
open System.Management.Automation
open System.Net.Http

/// Sends an SMS message to the specified Free Mobile account.
[<Cmdlet(VerbsCommunications.Send, "Message", DefaultParameterSetName = "Credential"); OutputType(typeof<Void>)>]
type SendMessageCommand() =
  inherit PSCmdlet()

  /// The message text.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Message = "" with get, set

  /// The Free Mobile client to use.
  [<Parameter(Mandatory = true, ParameterSetName = "Client")>]
  member val Client: Client | null = null with get, set

  /// The Free Mobile user name and password.
  [<Parameter(Mandatory = true, ParameterSetName = "Credential"); Credential>]
  member val Credential: PSCredential | null = null with get, set

  /// Performs initialization of the command execution.
  override this.BeginProcessing () =
    if this.ParameterSetName = "Credential" then this.Client <- new Client((nonNull this.Credential).GetNetworkCredential())

  /// Performs clean-up after the command execution.
  override this.EndProcessing () =
    if this.ParameterSetName = "Credential" then (nonNull this.Client).Dispose()

  /// Performs execution of this command.
  override this.ProcessRecord () =
    let client = nonNull this.Client
    try client.SendMessage this.Message
    with :? HttpRequestException as ex -> this.WriteError (ErrorRecord(ex, "Client.SendMessage", ErrorCategory.WriteError, client))
