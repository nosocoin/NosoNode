# API Reference: `nosodebug.pas`

The primary diagnostic and logging suite for NosoNode. It provides thread-safe profiling, error logging, and process monitoring.

## Performance Profiling

### `BeginPerformance(Tag: String)`
Starts a timer for a specific code section.

### `EndPerformance(Tag: String): Int64`
Ends the timer and calculates the duration in milliseconds.

### `PerformanceToFile(Destination: String): Boolean`
Exports the aggregated performance statistics (count, max, average) to a text file.

## Logging

### `AddLog(LogTag, NewLine: String)`
Thread-safe entry for specific log buffers (console, events, errors).

### `ToDeepDeb(LLine: String)`
Logs a line to the "Deep Debug" system used for tracing low-level consensus issues.

## Process Monitoring

### `UpdateOpenThread(ThName: String; TimeStamp: Int64)`
Registers or updates the activity of a background thread. used to detect "hanging" or deadlocked threads.

### `AddFileProcess(FiType, FiFile, FiPeer, TimeStamp)`
Logs the start of a disk I/O operation (e.g., writing a block).

### `CloseFileProcess(...)`
Logs the completion of a disk operation and returns the time taken.

## Accessors
- `GetProcessCopy()`: Returns a snapshot of all active threads for UI display.
- `GetLogLine(LogTag: String; out LineContent: String): Boolean`: Pops the oldest line from a log queue.
