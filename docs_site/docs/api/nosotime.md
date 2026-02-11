# API Reference: `nosotime.pas`

Handles all time-related operations, including NTP synchronization to ensure the node follows the global "Network Time."

## Time Retrieval

### `UTCTime(): Int64`
Returns the network-synchronized Unix timestamp. This value accounts for the local system clock offset.

### `UTCTimeStr(): String`
Returns the `UTCTime` as its string representation.

## Synchronization

### `UpdateOffset(NTPServers: String)`
Launches an asynchronous thread to query NTP servers and update the local time offset.

### `GetTimeOffset(NTPServers: String): Int64`
Synchronously queries NTP servers and returns the calculated clock drift.

## Blockchain Timing

### `BlockAge(): Integer`
Calculates how many seconds have passed since the current block round started (0-600 seconds).

### `IsBlockOpen(): Boolean`
Returns `true` if it's currently safe to process transactions/mine. Returns `false` durante the block transition period (start and end of the 10-minute round).

## Formatting
- `UnixToDateTime(UnixTime: Int64): TDateTime`: Conversion utility.
- `TimestampToDate(Timestamp: Int64): String`: Returns a human-readable date string.
