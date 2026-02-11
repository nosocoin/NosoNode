# API Reference: `nosoconsensus.pas`

This unit is responsible for calculating and managing the network consensus. It periodically queries peers to determine the "correct" state of the blockchain.

## Consensus Logic

### `CalculateConsensus(NodesList: String = ''): TConsensus`
The main algorithm for determining consensus. It collects data from connected nodes, evaluates the most frequent values for block height, hashes, and Masternode counts, and updates the local `Consensus` state.

### `GetConsensus(LData: Integer = 0): String`
Retrieves a specific value from the current consensus array.
Common indices:
- `cLastBlock (2)`: Consensus on current block height.
- `cLBHash (10)`: Consensus on the hash of the last block.
- `cSumHash (17)`: Consensus on the Summary (Balance) hash.
- `cGVTsHash (18)`: Consensus on the GVT file hash.

### `GetConHash(ILine: String): String`
Generates a unique hash for a "Node Status" line, allowing the system to quickly compare if two nodes are on the same branch.

## Automation

### `StartAutoConsensus()`
Launches a background thread (`TThreadAutoConsensus`) that triggers consensus calculations every 50 seconds.

### `StopAutoConsensus()`
Gracefully terminates the auto-consensus thread.

## Node Management

### `SetNodesArray(NodesList: String)`
Populates the list of peer nodes to be queried during the consensus round.

### `GetNodesArrayCount(): Integer`
Returns the number of nodes currently being used for consensus calculation.

## Secondary Types
- `TNodeConsensus`: Record containing the status data returned by a single node.
- `TConsensusData`: Internal structure for tallying the frequency of different node reports.
