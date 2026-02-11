# API Reference: `nosowallcon.pas`

A dedicated unit for managing the user's `wallet.pkw` file and the memory array of local addresses.

## Wallet Lifecycle

### `LoadWallet(wallet: String): Boolean`
Loads a `.pkw` file into the memory array for use in the application.

### `CreateNewWallet(): Boolean`
Generates a fresh `wallet.pkw` with a single, newly created address.

### `SaveWalletToFile(): Boolean`
Writes the current `WalletArray` to disk and creates a `.bak` backup file.

## Address Management

### `InsertToWallArr(LData: WalletData): Boolean`
Adds a new address structure to the active wallet list.

### `GetWallArrIndex(Index: Integer): WalletData`
Thread-safe retrieval of an address from the wallet array.

### `WallAddIndex(Address: String): Integer`
Finds the position of a specific Noso address in the local wallet.

## Utilities
- `VerifyAddressOnDisk(HashAddress: String): Boolean`: Checks if a specific address exists within the `wallet.pkw` file.
- `ClearWallPendings()`: Resets the "Pending" balance markers for all local addresses.
- `ImportAddressesFromBackup(BakFolder: String): Integer`: Merges `.pkw` files from a backup directory into the current session.
