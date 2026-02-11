# API Reference: `mpsyscheck.pas`

System-level audits to ensure the hardware and network environment are suitable for running a Noso Node.

## Performance Benchmarking

### `Sys_HashSpeed(cores: Integer): Int64`
Benchmarks the CPU's ability to calculate SHA256 hashes across multiple cores.

### `TestDownloadSpeed(): Int64`
Downloads a controlled file from the official repo to measure network bandwidth.

## Hardware Verification

### `AllocateMem(UpToMb: Integer): Int64`
Attempts to allocate a block of memory to confirm the OS supports the memory-intensive summary index.

## Automation
- `TThreadHashtest`: An internal worker thread used by `Sys_HashSpeed` to perform the actual benchmarking.
