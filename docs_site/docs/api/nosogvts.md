# API Reference: `nosogvts.pas`

This unit handles the Noso Voting Tokens (GVT), which are 100 non-fungible assets at the protocol level.

## Storage Operations

### `CreateGVTsFile(): Boolean`
Creates an empty `gvts.psk` file if it doesn't exist.

### `GetGVTsFileData()`
Loads the GVT database from disk into the `ArrGVTs` memory array.

### `SaveGVTs()`
Saves any changes made to `ArrGVTs` back to the disk file.

## Data Access

### `GetGVTIndex(Index: Integer): TGVT`
Retrieves the ownership data for a specific GVT index (0-99).

### `GetGVTLength(): Integer`
Returns the total number of GVTs in the system (always 100).

## Business Logic

### `ChangeGVTOwner(Lnumber: Integer; OldOwner, NewOwner: String): Integer`
Processes a GVT transfer. Returns `0` on success.

### `GetGVTPrice(available: Integer; ToSell: Boolean): Int64`
Calculates the current market price of a GVT based on the remaining supply in the development fund.

### `CountAvailableGVTs(): Integer`
Counts how many GVTs are currently owned by the project/dev fund.

## Record Format
- `TGVT`: Packed Record
  - `number`: String[2]
  - `owner`: String[32]
  - `Hash`: String[64]
  - `control`: Integer
