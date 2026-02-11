# API Reference: Diagnostics (`mpsyscheck.pas` & `nosodebug.pas`)

Tools for performance monitoring, debugging, and system requirements validation.

## `mpsyscheck.pas` (System Audit)

### `Sys_HashSpeed(cores: Integer): Int64`
Benchmarks the CPU's SHA256 hashing performance to estimate mining capability.

### `TestDownloadSpeed(): Int64`
Downloads a 1MB test file to determine if the network connection is sufficient for node operation.

### `AllocateMem(UpToMb: Integer): Int64`
Verifies the OS allows the application to allocate enough RAM for the summary index.

## `nosodebug.pas` (Debugging)

### `BeginPerformance(Tag: String) / EndPerformance(Tag: String)`
Wraps blocks of code with precise timers to identify bottlenecks in consensus or parsing.

### `ToDeepDeb(LLine: String)`
Writes a highly detailed trace line to the deep debug log (`debug_deep.txt`).

### `AddFileProcess(FiType, FiFile, FiPeer, TimeStamp)`
Active monitoring of file I/O operations (identifying sticking points in block writing).

### `InitDeepDeb(LFileName, SysInfo: String)`
Initializes the debug system at startup, logging OS version and hardware environment.

## `nosoipcontrol.pas` (Spam Control)

### `AddIPControl(ThisIP: String): Integer`
Increments an interaction counter for an IP. Used to detect and block "Spammy" peers that send too many requests.

### `ClearIPControls()`
Resets the IP rate-limiting table (usually at the start of a block).
