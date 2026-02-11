# NosoNode File Reference

This document provides a comprehensive accounting of every source file in the NosoNode project.

| File | Responsibility | Key Components |
| :--- | :--- | :--- |
| **Networking & Protocol** | | |
| `nosonetwork.pas` | Low-level TCP management | Socket slots, packet routing, thread safety |
| `mpprotocol.pas` | P2P Command Dispatcher | Parsing/constructing P2P messages |
| `mpred.pas` | Network Engine | Peer sync coordination and multi-slot management |
| `mpmn.pas` | MN Service Protocol | Masternode-specific network challenge/response |
| `nosoclient.pas` | TCP Client Wrapper | Bridge for NTP and external API requests |
| `nosoipcontrol.pas` | P2P Spam Control | IP-based rate limiting and protection |
| **Blockchain Logic** | | |
| `nosocensus.pas` | Consensus Engine | Calculating majority state from peer reports |
| `nosocrypto.pas` | Cryptography & Addresses | SHA256, SECP256K1, Base58, Address derivation |
| `mpsignerutils.pas` | ECC Primitives | Low-level secp256k1 key and sign wrappers |
| `nosounit.pas` | State Management | Summary index (balances) and global constants |
| `nosomasternodes.pas`| Masternode Directory | Registry of verified Masternodes and scores |
| `mpcoin.pas` | Transaction Logic | Mempool, balance calculation, and validation |
| `mpblock.pas` | Block Creation | Logic for building new blocks from the mempool |
| `nosoblock.pas` | Block Structure | Genesis block and binary block I/O logic |
| `nosogvts.pas` | GVT Assets | Noso Voting Token management and pricing |
| `nosopsos.pas` | Service Objects (PSO) | Protocol-level locking and voting metadata |
| **Persistence & Time** | | |
| `nosowallcon.pas` | Wallet Management | `.pkw` file I/O and secure key handling |
| `nosoheaders.pas` | Block Headers Index | Quick access to chain height and hashes |
| `nosotime.pas` | Network Time | NTP synchronization and block timing |
| `nosonosocfg.pas` | Node Configuration | Management of `nosocfg.psk` and seed nodes |
| `mpdisk.pas` | System Maintenance | Integrity checks, rescan logic, and backups |
| **UI & Interaction** | | |
| `masterpaskalform.pas`| Main Controller | Primary GUI, threading, and app lifecycle |
| `mpparser.pas` | CLI Parser | Interactive console command implementation |
| `mprpc.pas` | JSON-RPC API | External interface for wallets/explorers |
| `mpgui.pas` | GUI Data Binding | Updating screen elements from backend data |
| `mplang.pas` | Language Engine | Managing default string templates |
| `translation.pas` | Resource Strings | Centralized database of localized labels |
| `formexplore.pas` | File Explorer | Built-in dialog for file selection |
| **Diagnostics** | | |
| `nosodebug.pas` | Deep Logging | Profiling, thread monitoring, and trace logs |
| `mpsyscheck.pas` | System Audits | Hardware benchmarking and memory tests |

## Data & Database Files

These files are typically found in the `NOSODATA/` directory and constitute the node's state and history.

| File | Purpose | Logic Unit |
| :--- | :--- | :--- |
| `Summary.nos` | The main balance index (State) | `nosounit.pas`, `mpdisk.pas` |
| `blchhead.nos` | Binary index of block headers | `nosoheaders.pas` |
| `wallet.pkw` | Encrypted private keys & addresses | `nosowallcon.pas` |
| `nosocfg.psk` | Node configuration (Seeds, RPC, NTP) | `nosonosocfg.pas` |
| `gvts.psk` | GVT ownership database | `nosogvts.pas` |
| `psos.dat` | Protocol Service Objects database | `nosopsos.pas` |
| `*.blk` | Raw block files (one per block) | `mpblock.pas`, `nosoblock.pas` |
| `AdvOpt.txt` | Advanced UI and RPC credentials | `mpdisk.pas` |
| `logs/*.txt` | Operation and error logs | `nosodebug.pas` |

## Subdirectories

- **`Packages/`**: Third-party Pascal packages (Indy, DCPCrypt, etc.).
- **`NOSODATA/`**: Default directory for data files (Blocks, Summary, Logs).
- **`Deprecated/`**: Legacy code and unused modules.
- **`ssl/`**: SSL certificates for secure communication.
- **`languages/`**: Translation files (e.g., `default.txt`).
