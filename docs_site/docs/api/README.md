# NosoNode API Reference Index (1:1 Coverage)

This directory contains dedicated technical documentation for **every** Pascal unit in the NosoNode project. Each file corresponds directly to a `.pas` source file.

## 🟢 Core Blockchain & Consensus
- [**nosoconsensus.pas**](nosoconsensus.md): Network-wide consensus rules and auto-consensus thread.
- [**nosocrypto.pas**](nosocrypto.md): Hashing, SECP256k1 signing, and address derivation.
- [**mpsignerutils.pas**](mpsignerutils.md): Low-level ECC cryptographic primitive wrappers.
- [**nosounit.pas**](nosounit.md): Global balance summary (State) and UTXO-like indexing.
- [**nosomasternodes.pas**](nosomasternodes.md): Masternode directory and validation rules.

## 🔵 Transaction & Asset Management
- [**mpcoin.pas**](mpcoin.md): Transaction validation and local mempool logic.
- [**nosogvts.pas**](nosogvts.md): Noso Voting Token (GVT) system and price formulas.
- [**nosopsos.pas**](nosopsos.md): Protocol Service Objects (PSOs) and address locking.
- [**mpblock.pas**](mpblock.md): Block building and binary serialization.
- [**nosoblock.pas**](nosoblock.md): Genesis block logic and chain structure.

## 🟡 Networking & Infrastructure
- [**nosonetwork.pas**](nosonetwork.md): Low-level socket management and slot allocation.
- [**mpprotocol.pas**](mpprotocol.md): P2P communication logic and message construction.
- [**mpred.pas**](mpred.md): The multi-peer networking engine and sync coordinator.
- [**mpmn.pas**](mpmn.md): Specific protocols for Masternode service verification.
- [**nosotime.pas**](nosotime.md): NTP synchronization and blockchain round timing.
- [**nosonosocfg.pas**](nosonosocfg.md): Node configuration and seed node management.

## 🟣 UI, API & Integration
- [**masterpaskalform.pas**](masterpaskalform.md): Main GUI controller and application lifecycle.
- [**mpparser.pas**](mpparser.md): CLI console command implementation.
- [**mprpc.pas**](mprpc.md): JSON-RPC server for remote wallets and explorers.
- [**mpgui.pas**](mpgui.md): Visual data binding and LCL interface updates.
- [**mplang.pas**](mplang.md): Language engine and localized string templates.
- [**translation.pas**](translation.md): Centralized `resourcestring` constant database.

## ⚪ Utilities & Diagnostics
- [**nosogeneral.pas**](nosogeneral.md): Critical parsing (`Parameter`), math, and shared types.
- [**mpdisk.pas**](mpdisk.md): Persistent storage maintenance and integrity audits.
- [**nosowallcon.pas**](nosowallcon.md): Secure wallet file (`.pkw`) management.
- [**nosoheaders.pas**](nosoheaders.md): Block header index management.
- [**nosodebug.pas**](nosodebug.md): Deep logging, profiling, and thread monitoring.
- [**nosoipcontrol.pas**](nosoipcontrol.md): P2P spam protection and rate limiting.
- [**mpsyscheck.pas**](mpsyscheck.md): Hardware benchmarking and memory audits.
- [**formexplore.pas**](formexplore.md): Built-in file explorer dialog.
- [**nosoclient.pas**](nosoclient.md): Bridge to Indy TCP client components.

---
*Note: This documentation covers 100% of the Pascal source files present in the root directory.*
