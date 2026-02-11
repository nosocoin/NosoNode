# API Reference: `mplang.pas`

Manages the core language engine and the default English translation strings.

## Logic

### `LoadDefLangList()`
Populates the global `DLSL` (Default Language String List) with English UI labels and error messages.

### `CrearArchivoLang()`
Generates a `default.txt` file in the `languages/` directory, which can be modified for multi-language support.

## Initialization
This unit is called early in the `StartProgram` routine in `masterpaskalform.pas` to ensure the UI is localized before it is displayed to the user.
