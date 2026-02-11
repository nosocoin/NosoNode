# API Reference: `nosonosocfg.pas`

Manages the primary configuration of the NosoNode, typically stored in `nosocfg.psk`.

## Configuration Access

### `GetCFGDataStr(LParam: Integer = -1): String`
Retrieves a specific configuration string or the entire configuration file.
Parameters:
- `-1`: Full config string.
- `0`: Specific line index.

### `SetCFGData(DataToSet: String; CFGIndex: Integer)`
Updates a specific configuration field in memory and prepares it for disk sync.

## Security & Verification

### `GetCFGHash(): String`
Returns the MD5 hash of the current configuration, used to verify consensus among peers.

### `IsSeedNode(IP: String): Boolean`
Checks if a given IP address belongs to the trusted list of hardcoded or network-provided seed nodes.

## Defaults
- `SetDefaultCFG()`: Reverts the node to the out-of-the-box network settings (Seed nodes, NTP servers, etc.).
- `GetNTPNodes()`: Returns the string of NTP servers for time sync.
