# API Reference: GUI & Localisation (`mpgui.pas` & `mplang.pas`)

These units manage visual representation and multi-language support.

## `mpgui.pas` (Interface Logic)

### `ActualizarGUI()`
The master UI update routine. Called periodically to sync the visual state with the underlying blockchain data.

### `UpdateSlotsGrid()`
Specific logic for updating the "Connections" table, showing IP, version, and sync progress for every peer.

### `GetConnectedPeers(): String`
Returns a human-readable list of all currently verified and active peer connections.

### `ThisPercent(percent, thiswidth: Integer): Integer`
Helper for calculating responsive widget sizes in the Lazarus LCL.

## `mplang.pas` (Language Management)

### `LoadDefLangList()`
Populates the default English string list (`DLSL`) with all hardcoded UI labels.

### `CrearArchivoLang()`
Generates a `default.txt` language file on disk if no translation is found. This serves as the template for community translations.

## `translation.pas` (Resource Strings)
Contains the `resourcestring` section for Pascal's native localization system.
- `rs0001` to `rs2505`: Indexed strings for errors, labels, and status messages.
