namespace Belin.FreeMobile

open System
open System.Management.Automation

/// Releases the resources associated with the specified client.
[<Cmdlet(VerbsCommon.Close, "Client"); OutputType(typeof<Void>)>]
type CloseClient() =
  inherit Cmdlet()

  /// The Free Mobile client to dispose.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val InputObject: Client | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = (nonNull this.InputObject).Dispose()

/// Creates a new Free Mobile client.
[<Cmdlet(VerbsCommon.New, "Client"); OutputType(typeof<Client>)>]
type NewClient() =
  inherit Cmdlet()

  /// The assembly version.
  static let version = SemanticVersion (typeof<NewClient>.Assembly.GetName().Version)

  /// The Free Mobile user name and password.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true); Credential>]
  member val Credential: PSCredential | null = null with get, set

  /// The user agent string to use when making requests.
  [<Parameter; ValidateNotNullOrWhiteSpace>]
  member val UserAgent = $"PowerShell/{PSVersionInfo.PSVersion} | Belin.FreeMobile/{version}" with get, set

  /// The base URL of the remote API endpoint.
  [<Parameter; ValidateNotNull>]
  member val Uri = Uri "https://smsapi.free-mobile.fr/" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord () = this.WriteObject (new Client(
    (nonNull this.Credential).GetNetworkCredential(),
    BaseUrl = this.Uri,
    UserAgent = this.UserAgent
  ))
