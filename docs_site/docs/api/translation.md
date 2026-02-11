# API Reference: `translation.pas` (Strings)

A dedicated unit containing the `resourcestring` constants for the Pascal compiler.

## Usage

This unit acts as a centralized database of all UI label and error messages. Using `resourcestring` allows for easier external translation without recompiling the core logic.

### String Groups
- `rs0001` - `rs0093`: Networking, Server, and Core Node events.
- `rs0500` - `rs0517`: GUI Labels and Grid Headers.
- `rs1000` - `rs1004`: Disk and Blockchain processing errors.
- `rs1501` - `rs1505`: Transaction and Parser specific messages.
- `rs2000` - `rs2003`: Network Engine status messages.
- `rs2501` - `rs2505`: Cryptographic critical failures.
