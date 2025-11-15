# SkillChain Smart Contract

ink! smart contract for the SkillChain professional reputation protocol.

## Overview

`SkillChainRegistry` is a decentralized reputation system that allows:
- Users to register professional profiles on-chain
- Entities to issue claims (validations/acknowledgments) to users
- Issuers to approve their own claims
- Anyone to query profiles and reputation data

## Features

- ✅ Profile registration with off-chain metadata
- ✅ Claim issuance with flexible types
- ✅ Approval workflow (issuer-only)
- ✅ Public querying of profiles and claims
- ✅ Event emission for indexing
- ✅ Custom error handling
- ✅ Comprehensive test suite (13+ tests)

## Build

```bash
# Build release version
./build.sh

# Or manually
cargo contract build --release
```

Build artifacts are generated in `target/ink/`:
- `skillchain.contract` - Contract bundle
- `skillchain.wasm` - WASM bytecode
- `metadata.json` - ABI metadata

## Test

```bash
# Run all tests
cargo test

# Run specific test
cargo test test_register_profile_success

# With output
cargo test -- --nocapture
```

**Test Coverage:** 13 unit tests covering all functions and error cases.

## Deploy

### Local Node

1. Start node:
```bash
substrate-contracts-node --dev --tmp
```

2. Deploy using Polkadot.js Apps UI or CLI:
```bash
cargo contract upload --suri //Alice
cargo contract instantiate --suri //Alice --constructor new
```

### Testnet (Paseo)

```bash
cargo contract build --release
cargo contract upload --url wss://paseo.rpc.endpoint --suri "your-seed"
cargo contract instantiate --url wss://paseo.rpc.endpoint --suri "your-seed" --constructor new
```

## Public Functions

### `register_profile(metadata_uri: String) -> Result<()>`
Register a new profile with link to off-chain metadata.

### `add_claim(receiver: AccountId, claim_type: String, proof_hash: Hash) -> Result<u64>`
Issue a claim to another user. Returns claim ID.

### `approve_claim(claim_id: u64) -> Result<()>`
Approve a claim (only by issuer).

### `get_profile(account_id: AccountId) -> Option<Profile>`
Query a user's profile.

### `get_claims(account_id: AccountId) -> Vec<Claim>`
Get all claims for a user.

## Data Structures

```rust
struct Profile {
    owner: AccountId,
    metadata_uri: String,
}

enum ClaimStatus {
    Pending,
    Approved,
}

struct Claim {
    id: u64,
    issuer: AccountId,
    receiver: AccountId,
    claim_type: String,
    proof_hash: Hash,
    status: ClaimStatus,
}
```

## Events

- `ProfileRegistered { owner, metadata_uri }`
- `ClaimAdded { claim_id, issuer, receiver, claim_type }`
- `ClaimApproved { claim_id }`

## Errors

- `ProfileAlreadyExists` - User already has a profile
- `ClaimNotFound` - Invalid claim ID
- `UnauthorizedApproval` - Only issuer can approve
- `ClaimAlreadyApproved` - Claim already approved

## Documentation

See [Technical Documentation](../../docs/smart_contracts_en.md) for detailed information.

## License

MIT

