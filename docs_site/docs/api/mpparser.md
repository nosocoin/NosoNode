# API Reference: CLI Parser (`mpparser.pas`)

This unit implements the interactive console command system for the NosoNode.

## Command Dispatcher

### `Parse_Command(Linetext: String)`
The main entry point for user interaction. Tokenizes the input and executes the appropriate procedure.

### Key Console Commands:
| Command | Description |
| :--- | :--- |
| `STATUS` | Shows sync progress, connected peers, and block height. |
| `PEERS` | Lists active P2P connections. |
| `NODES` | Lists hardcoded seed nodes. |
| `GETPENDING` | Force pulls the latest mempool from peers. |
| `RESUMEN [block]` | Displays headers and summary for a specific height. |
| `CUSTOMIZE [address] [alias]` | Issues a customization transaction. |
| `SENDREPORTS` | Collects debug logs and uploads them to the dev team. |

## Internal Logic
- `GetWalletBalance()`: Aggregates balances of all addresses in `wallet.pkw`.
- `OutgoingMsjsGet()`: Retrieves messages from the console outbox for display in the UI.
