# API Reference: `mpgui.pas`

Handles the visual state transitions and data binding for the Lazarus LCL interface.

## High-Level Logic

### `ActualizarGUI()`
The master timer-driven routine that updates labels, grids, and status icons based on the background blockchain threads.

### `IniciaGrids()`
Configures the columns and headers for all UI tables (Wallet, Peers, Transactions, Masternodes).

### `OutgoingMsjsAdd(Message: String)`
Adds a message to the internal UI outbox for display in the console or status bar.

## Grid Management

### `UpdateSlotsGrid()`
Updates the "Connections" table with real-time peer data (IP, Port, Version, Status).

### `UpdateSummaryGrid()`
Refreshes the balance display for addresses in the user's wallet.

## Layout Utilities

### `ThisPercent(percent, thiswidth: Integer; RestarBarra: Boolean): Integer`
Returns a pixel value based on a percentage of the window width. Used for responsive UI scaling.

### `TimeSinceStamp(Stamp: Int64): String`
Converts internal timestamps into human-readable duration strings (e.g., "5s ago").
