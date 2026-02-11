# API Reference: Assets (`nosogvts.pas` & `nosopsos.pas`)

Noso assets beyond simple currency: GVTs (Noso Voting Tokens) and PSOs (Protocol Service Objects).

## `nosogvts.pas` (GVT Token)

### `CreateGVTsFile(): Boolean`
Initializes the binary structure for the 100 limited supply GVTs.

### `ChangeGVTOwner(Lnumber: Integer; OldOwner, NewOwner: String): Integer`
The core logic for transferring a GVT. Validates ownership and address format.

### `GetGVTPrice(available: Integer; ToSell: Boolean): Int64`
Calculates the dynamic price of a GVT based on how many remain in the development fund.

### `GetGVTsAsStream(out LStream: TMemoryStream): Int64`
Serializes all tokens for network propagation during sync.

## `nosopsos.pas` (Service Objects)

### `AddNewPSO(LMode, LOwner, LExpire, LParams): Boolean`
Registers a new Service Object (e.g., Masternode Locks, Voting proposals).

### `IsLockedMN(Address: String): Boolean`
Checks if a Masternode address is currently under a "Lock" PSO (preventing withdrawal/move during a round).

### `LoadPSOFileFromDisk(): Boolean`
Reads the `psos.dat` file and rebuilds the active service object table in memory.

### `LockedMNsRawString(): String`
Returns a protocol-encoded string of all locked addresses for sharing with peers.
