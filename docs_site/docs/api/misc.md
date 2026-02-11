# API Reference: Miscellaneous (`formexplore.pas` & `nosopsos.pas`)

UI utilities and specialized protocol extensions.

## `formexplore.pas` (File Explorer)

### `ShowExplorer(Directory, Title, Mask, Callback: String)`
Displays a custom, cross-platform file selection dialog within the application. Used for importing wallets or loading update files.

### `LoadDirectory(Directory: String)`
Populates the explorer grid with the contents of a specific filesystem path.

### `FSBOkFileOnClick(Sender: TObject)`
The confirmation handler that returns the selected file path to the calling module.

## `nosoclient.pas` (Client Wrapper)
A minimal unit providing a bridge to the Indy `TIdTCPClient` components used in Masternode verification and NTP sync.

## `translation.pas` (Native Strings)
The central repository for `resourcestring` constants. This allows the LCL (Lazarus Component Library) to swap UI text dynamically without reloading the executable.
