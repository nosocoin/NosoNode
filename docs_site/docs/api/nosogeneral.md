# API Reference: `nosogeneral.pas`

This unit contains the foundational utility functions and shared types used throughout the project.

## Public Functions

### `Parameter(LineText: String; ParamNumber: int64; de_limit: String = ' '): String`
Critical utility for parsing space-delimited strings (P2P protocol, config lines, console input). Supports parentheses to group parameters.

### `Int2Curr(Value: Int64): String`
Converts internal 8-decimal integer representation to a formatted currency string (e.g., `100000000` -> `1.00000000`).

### `GetSupply(Block: Integer): Int64`
Calculates the total potential coin supply at a specific block height.

### `GetFee(Amount: Int64): Int64`
Calculates the standard transaction fee for a given amount (default 0.01%, minimum 0.01 Noso).

### `GetProjectShare(Block: Integer): Int64`
Calculates the developer/project reward percentage for the given block.

## File Utilities
- `SaveTextToDisk(filename, content: String)`: Atomic file write wrapper.
- `LoadTextFromDisk(filename: String)`: File read wrapper.

## Shared Structures
- `TOrderData`: The primary transaction record (Detailed in [DATA_STRUCTURES](../DATA_STRUCTURES.md)).
- `TMultiOrder`: Support for multi-recipient transfers.
