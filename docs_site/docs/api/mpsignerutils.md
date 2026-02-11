# API Reference: `mpsignerutils.pas`

A low-level utility wrapper for the `CryptoLib4Pascal` library, handling ECDSA (secp256k1) key generation and signing.

## Key Management

### `GenerateECKeyPair(AKeyType: TKeyType): TKeyPair`
Generates a new ECC public/private keypair. By default, Noso uses `TKeyType.SECP256K1`.

## Signing Operations

### `SignMessage(const message: TBytes; const PrivateKey: TBytes; AKeyType: TKeyType): TBytes`
Signs a raw byte array with a private key. Used for transactions and Masternode advertisements.

### `VerifySignature(const signature, message, PublicKey: TBytes; AKeyType: TKeyType): Boolean`
Verifies that a signature was indeed created by the holder of the provided public key.

## Data Conversion

### `ByteToString(const Value: TBytes): String`
Converts a byte array to its raw character string representation.

### `StrToByte(const Value: String): TBytes`
Converts a raw string into a byte array for cryptographic processing.

## Internal Structures
- `TKeyPair`: Record containing `PublicKey` and `PrivateKey` as strings.
- `TKeyType`: Enum for supported curves (SECP256K1, SECP384R1, SECP521R1, SECT283K1).
