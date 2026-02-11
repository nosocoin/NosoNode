# API Reference: `mpmn.pas`

Specifically handles the low-level synchronization and verification of Masternodes.

## Node Verification

### `TThreadMNVerificator` (Class)
The thread implementation that connects to a target IP/Port to confirm it is an active Noso Masternode.

### `ValidatorsCount(): Integer`
Returns the number of nodes currently participating in the Masternode verification round.

## Network Propagation

### `SendMNsList(Slot: Integer)`
Pushes the local database of verified Masternodes to a specific peer.

### `CheckMNReport(LineText: String; block: Integer)`
Parses a peer's Masternode report and determines if it should be added to the local list.

## Formatting

### `GetStringFromMN(Node: TMNode): String`
Serializes a `TMNode` record into a space-delimited string for protocol transit.

### `GetMNodeFromString(StringData: String; out ToMNode: TMNode): Boolean`
Deserializes a protocol string back into the `TMNode` record structure.

## Utilities
- `ClearMNsList()`: Resets the Masternode registry.
- `GetVerificationMNLine(ToIp: String): String`: Generates the unique challenge string used to verify a Masternode's authenticity.
