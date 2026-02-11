# NosoNode Data Structures

Detailed specification of the core records and data formats used in the Nosocoin protocol.

## 1. Transaction (Order) Data
Defined in `nosogeneral.pas` as `TOrderData`.

| Field | Type | Description |
| :--- | :--- | :--- |
| `Block` | Integer | Block number this transaction belongs to |
| `OrderID` | String[64] | Unique identifier for the transaction |
| `OrderLines` | Integer | Number of sub-lines (for multi-transfers) |
| `OrderType` | String[6] | `TRFR` (Transfer), `CUSTOM`, `PROJCT`, etc. |
| `TimeStamp` | Int64 | Unix timestamp |
| `Reference` | String[64] | Optional text reference |
| `sender` | String[120] | Public key or address of the sender |
| `Address` | String[40] | Sender's address |
| `Receiver` | String[40] | Recipient's address |
| `AmmountFee` | Int64 | Transaction fee (8 decimals precision) |
| `AmmountTrf` | Int64 | Amount to transfer |
| `Signature` | String[120] | Cryptographic signature |
| `TrfrID` | String[64] | Internal transfer ID |

## 2. Block Header
Defined in `nosoblock.pas` as `BlockHeaderData`.

| Field | Type | Description |
| :--- | :--- | :--- |
| `Number` | Int64 | Block height |
| `TimeStart` | Int64 | Start of mining block time |
| `TimeEnd` | Int64 | Time block was closed |
| `TimeTotal` | Integer | Resolution time in seconds |
| `TrxTotales` | Integer | Count of transactions in block |
| `Difficult` | Integer | Difficulty target |
| `TargetHash` | String[32] | Required PoW prefix/hash |
| `Solution` | String[200] | Miner's solution |
| `LastBlockHash`| String[32] | Hash of the previous block |
| `AccountMiner` | String[40] | Miner's reward address |
| `Reward` | Int64 | Block subsidy |

## 3. Masternode Data
Defined in `nosomasternodes.pas` as `TMNode`.

| Field | Type | Description |
| :--- | :--- | :--- |
| `Ip` | String[15] | Node's IPv4 address |
| `Port` | Integer | P2P Port |
| `Sign` | String[40] | Signing address |
| `Fund` | String[40] | Collateral (Noso stack) address |
| `First` | Integer | First block valid |
| `Validations` | Integer | Successful verification count in current round |

## 4. Serialization Formats

### Text Serialization
Used for P2P messages and some local files.
- **Delimiter**: Space (` `)
- **Nested Delimiter**: Colon (`:`) or Semicolon (`;`) for lists.

### Binary Serialization
Blocks (`.blk`) and Summary (`.nos`) files are stored as binary packed records.
> [!CAUTION]
> Changing the record definition breaks file compatibility without a migration path.
