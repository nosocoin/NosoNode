# API Reference: `nosoipcontrol.pas`

A simple but essential security unit for tracking and limiting interactions from remote IP addresses.

## Rate Limiting

### `AddIPControl(ThisIP: String): Integer`
Increments the interaction counter for a specific IP. Returns the current count.
Used to detect "spammy" connections that send too many requests in a single block.

### `ClearIPControls()`
Resets the entire IP tracking table. This is typically done at the start of a new block.

## Global State
- `ArrCont`: Array of `IPControl` records.
- `LastIPsClear`: Unix timestamp of the last reset.

## Record Format
- `IPControl`: Record
  - `IP`: String
  - `Count`: Integer
