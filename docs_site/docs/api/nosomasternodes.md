# API Reference: `nosomasternodes.pas`

Handles the Masternode (MN) ecosystem, including registration, storage, and verification.

## Data Types
- `TMNode`: Packed record representing an active Masternode.
- `TMNCheck`: Record of a verification performed by one MN on another peer.

## Masternode Verification

### `RunMNVerification(...)`
Launches the verification round.
1. Creates a pool of threads (`TThreadMNVerificator`).
2. Each thread connects to a peers and verifies their status via `MNVER` command.
3. Collects results into the `VerifiedNodes` string.

### `CreditMNVerifications()`
Processes the collected `ArrMNChecks` and updates the validation counters for active Masternodes in the current round.

## Management

### `GetMNsAddresses(Block: Integer): String`
Exports the list of valid Masternodes to a text format for persistence in `masternodes.txt`.

### `IsLegitNewNode(ThisNode: TMNode; block: Integer): Boolean`
Validation logic for new MN announcements. Checks for duplication of IPs, signing addresses, and collateral funds.

### `GetMNsHash(): String`
Calculates the MD5 hash of the local `masternodes.txt` file for network consensus.

## Helper Functions
- `GetMNodeFromString`: Deserializer for Masternode announcements.
- `GetStringFromMN`: Serializer for Masternode announcements.
