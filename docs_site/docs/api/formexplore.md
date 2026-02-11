# API Reference: `formexplore.pas`

Provides a custom, minimalist file explorer UI built inside the NosoNode application.

## Logic

### `ShowExplorer(Directory, titulo, mascara, lineaaprocesar: String; fijarnombre: Boolean)`
Opens the explorer window.
- `mascara`: File filter (e.g., `*.pkw`).
- `lineaaprocesar`: A console command to execute once a file is chosen.

### `LoadDirectory(Directory: String)`
Populates the grid with folders and files from the target path.

### `CloseExplorer()`
Hides the explorer window.

## UI Handlers
- `FSBOkFileOnClick`: Triggered when the user confirms their selection.
- `SBUpPathClick`: Navigates to the parent directory.

## Utility
- `OnlyName(conpath: String): String`: Extracts the filename from a full absolute path.
