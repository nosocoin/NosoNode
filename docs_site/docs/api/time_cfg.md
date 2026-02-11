# API Reference: Time & Configuration (`nosotime.pas` & `nosonosoCFG.pas`)

These units ensure the node is synchronized and correctly configured.

## `nosotime.pas` (Synchronization)

### `UTCTime(): Int64`
Returns the network-synchronized Unix timestamp. This is essential as the protocol depends on a shared "Network Time".

### `GetTimeOffset(NTPServers: String): Int64`
Queries multiple NTP servers to calculate the local system's clock drift.

### `BlockAge(): Integer`
Returns the seconds elapsed since the start of the current 10-minute block (0 to 600).

### `IsBlockOpen(): Boolean`
Returns `True` if it is safe to mine or send transactions. Returns `False` during "Block Closing" periods (first 10 and last 15 seconds of a round).

## `nosonosoCFG.pas` (Network Configuration)

### `GetCFGDataStr(LParam: Integer): String`
Retrieves a specific configuration string (e.g., `1` for Seed Nodes, `2` for NTP Servers).

### `SetCFGData(DataToSet: String; CFGIndex: Integer)`
Updates the local `nosocfg.psk` file.

### `IsSeedNode(IP: String): Boolean`
Checks if a connecting peer is one of the hardcoded or downloaded trusted seed nodes.

## Persistence
All sync and config data is stored in `NOSODATA/nosocfg.psk`.
