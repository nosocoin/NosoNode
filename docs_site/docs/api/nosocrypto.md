# API Reference: `nosocrypto.pas` (Exhaustive)

The core cryptographic engine of NosoNode, utilizing SHA-256, SECP256k1, and specialized base conversions.

## Address Generation

### `GenerateNewAddress(out pubkey, out privkey): String`
The primary method for creating a new Noso address. Generates an EC keypair and derives the Base58-Check hash.

### `GetAddressFromPublicKey(PubKey: String): String`
Derives a Noso address from a public key using the standard routine: `SHA256 -> RIPEMD160 -> Base58 -> Checksum`.

### `IsValidHashAddress(Address: String): Boolean`
Validates the format and checksum of a Noso address.

## Digital Signatures

### `GetStringSigned(StringToSign, PrivateKey: String): String`
Signs a message using the SECP256k1 algorithm. Returns a Base64 encoded signature.

### `VerifySignedString(Message, Signature, Publickey: String): Boolean`
Authenticates a message signature against a public key.

## Hashing Utilities

### `HashSha256String(StringToHash: String): String`
Returns the hex-encoded SHA2-256 hash of a string.

### `HashMD160String(StringToHash: String): String`
Returns the hex-encoded RIPEMD-160 hash of a string.

### `CheckHashDiff(Target, ThisHash: String): String`
Calculates the "distance" between two hashes for Proof-of-Work validation.

## Base Conversions (Arbitrary Precision)

Noso uses custom alphanumeric bases for address compression and ID generation.

| Method | Description |
| :--- | :--- |
| `B16toB58` | Hexadecimal to Base58 (Noso Alphabet). |
| `B16ToB36` | Hexadecimal to Base36. |
| `B10toB58` | Decimal (String) to Base58. |
| `BMDecTo58` | BigInt Decimal to Base58. |
| `BMHexToDec` | BigInt Hex to Decimal. |

## Certificates

### `GetCertificate(Pubkey, privkey, currtime): String`
Generates a "Certification of Ownership" string, proving the holder owns the private key at a specific time.

### `CheckCertificate(certificate: String; out TimeStamp: String): String`
Validates a certificate and extracts the verified address and timestamp.
