# API Reference: `masterpaskalform.pas` (Main Controller)

This unit defines the main `TForm1` class and manages the application lifecycle, threading, and global synchronization.

## Threading Classes
- `TCryptoThread`: Background thread dedicated to CPU-intensive hashing and PoW.
- `TUpdateMNs`: Manages the periodic refresh of the Masternode list.
- `TUpdateLogs`: Handles thread-safe updates to the console UI.
- `TServerTipo`: The main TCP server thread wrapper.

## Core Application Methods

### `StartProgram()`
The primary initialization routine. Sets up data paths, loads configuration, initializes critical sections, and starts background threads.

### `RestartTimerEjecutar(sender: TObject)` / `InicoTimerEjecutar(sender: TObject)`
Timer-based callbacks for periodic tasks (UI refreshes, connection health checks).

### `ConsoleLineKeyup(...)`
Handles the interactive CLI input within the GUI console.

### `StartServer()` / `StopServer()`
Toggles the node's ability to accept incoming P2P connections.

## UI Data Management

### `UpdateDataPanel()`
Refreshes the sidebar/header information (Sync status, Node count, Balance, Hashing speed).

### `IniciaGrids()`
Initializes the appearance and structure of the transaction and peer grids.

### `ToLog(Tag, Text: String)`
Global logging entry point. Tags include `console`, `events`, `debug`, `exceps`.

## Networking Hooks
- `ServerConnect`: Triggered when a new peer connects to this node.
- `ServerDisconnect`: Cleanup logic when a peer disconnects.
- `ServerExecute`: The main loop handling data streams from connected clients.
