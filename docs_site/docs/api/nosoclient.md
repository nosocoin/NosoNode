# API Reference: `nosoclient.pas`

A minimal wrapper unit that manages the Indy `TIdTCPClient` components for specific outgoing requests.

## Implementation Details

This unit is primarily used to provide a clean interface for:
- NTP Time updates.
- External IP detection.
- Legacy Masternode polling.

It relies on the standard `IdTCPClient` library and acts as a bridge between the core P2P networking and the system utility calls.
