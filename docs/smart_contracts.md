# SkillChain Smart Contract - Technical Documentation

## Contract Overview

The **SkillChainRegistry** is an ink! smart contract that implements a decentralized professional reputation system on Polkadot. It allows users to:

- Register professional profiles on-chain
- Issue claims (acknowledgments/validations) to other users
- Approve claims to officially validate achievements
- Query profiles and reputation data transparently

This contract serves as the core infrastructure for the SkillChain protocol, enabling trustless verification of professional accomplishments in Web3.

**Contract Name:** `SkillChainRegistry`  
**Language:** Rust (ink! v4+)  
**Target:** WASM  
**Location:** `/contracts/skillchain/`

---

## Architecture

The contract is organized into modular sections within `lib.rs`:

```rust
lib.rs
├── Types Module        // Data structures (Profile, Claim, ClaimStatus)
├── Errors Module       // Custom error types
├── Events Module       // Contract events
├── Storage Module      // Storage structure
├── Contract Impl       // Public functions
├── Unit Tests          // Test suite
└── E2E Tests          // End-to-end tests
```

This modular structure enhances:
- Code readability
- Maintainability
- Testing isolation
- Security auditing

---

## Data Structures

### Profile

Represents a user's professional profile on-chain.

```rust
pub struct Profile {
    pub owner: AccountId,
    pub metadata_uri: String,
}
```

**Fields:**
- `owner`: Polkadot account address that owns the profile
- `metadata_uri`: URI pointing to off-chain metadata (IPFS, Arweave, etc.)

**Metadata Format (off-chain):**
```json
{
  "name": "Alice Developer",
  "bio": "Full-stack Web3 developer",
  "avatar": "ipfs://QmAvatarHash...",
  "skills": ["Rust", "Substrate", "React"],
  "links": {
    "github": "https://github.com/alice",
    "twitter": "https://twitter.com/alice"
  }
}
```

### ClaimStatus

Represents the approval state of a claim.

```rust
pub enum ClaimStatus {
    Pending,
    Approved,
}
```

**Variants:**
- `Pending`: Claim has been issued but not yet approved
- `Approved`: Claim has been officially validated by the issuer

### Claim

Represents an achievement or validation issued to a user.

```rust
pub struct Claim {
    pub id: u64,
    pub issuer: AccountId,
    pub receiver: AccountId,
    pub claim_type: String,
    pub proof_hash: Hash,
    pub status: ClaimStatus,
}
```

**Fields:**
- `id`: Unique identifier for the claim
- `issuer`: Account that issued the claim
- `receiver`: Account that receives the claim
- `claim_type`: Type of achievement (e.g., "hackathon_win", "job_completed")
- `proof_hash`: Hash of off-chain proof (IPFS link, transaction hash, etc.)
- `status`: Current approval status (`Pending` or `Approved`)

---

## Public Functions

### 1. `register_profile`

Register a new professional profile for the caller.

**Signature:**
```rust
pub fn register_profile(&mut self, metadata_uri: String) -> Result<()>
```

**Parameters:**
- `metadata_uri`: URI pointing to off-chain profile metadata

**Returns:**
- `Ok(())` on success
- `Err(ContractError)` on failure

**Errors:**
- `ProfileAlreadyExists`: Account already has a registered profile

**Events:**
- `ProfileRegistered { owner, metadata_uri }`

**Example Usage:**
```rust
// Register profile with IPFS metadata
contract.register_profile("ipfs://QmProfileMetadata123".to_string())
```

**JSON-RPC Call:**
```json
{
  "method": "register_profile",
  "params": ["ipfs://QmProfileMetadata123"]
}
```

---

### 2. `add_claim`

Issue a claim (acknowledgment) to another user.

**Signature:**
```rust
pub fn add_claim(
    &mut self,
    receiver: AccountId,
    claim_type: String,
    proof_hash: Hash
) -> Result<u64>
```

**Parameters:**
- `receiver`: Account that will receive the claim
- `claim_type`: Type of claim (flexible string, e.g., "hackathon_win", "contribution")
- `proof_hash`: Hash representing off-chain proof

**Returns:**
- `Ok(claim_id)`: Unique ID of the created claim
- `Err(ContractError)` on failure

**Events:**
- `ClaimAdded { claim_id, issuer, receiver, claim_type }`

**Example Usage:**
```rust
// OFFER-HUB issues a claim to a freelancer
let claim_id = contract.add_claim(
    freelancer_address,
    "job_completed".to_string(),
    Hash::from([0x12, 0x34, ...]) // Hash of proof
).unwrap();
```

**JSON-RPC Call:**
```json
{
  "method": "add_claim",
  "params": [
    "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY",
    "hackathon_win",
    "0x1234567890abcdef..."
  ]
}
```

**Common Claim Types:**
- `"hackathon_win"` - Won a hackathon
- `"job_completed"` - Successfully completed a job/project
- `"contribution"` - Contributed to a repository
- `"skill_endorsement"` - Skill validation
- `"bounty_completed"` - Completed a bounty
- `"audit_passed"` - Security audit passed

---

### 3. `approve_claim`

Approve a claim (only by the issuer).

**Signature:**
```rust
pub fn approve_claim(&mut self, claim_id: u64) -> Result<()>
```

**Parameters:**
- `claim_id`: ID of the claim to approve

**Returns:**
- `Ok(())` on success
- `Err(ContractError)` on failure

**Errors:**
- `ClaimNotFound`: Claim doesn't exist
- `UnauthorizedApproval`: Caller is not the issuer
- `ClaimAlreadyApproved`: Claim is already approved

**Events:**
- `ClaimApproved { claim_id }`

**Example Usage:**
```rust
// Issuer approves their own claim
contract.approve_claim(5).unwrap();
```

**JSON-RPC Call:**
```json
{
  "method": "approve_claim",
  "params": [5]
}
```

**Note:** Only the issuer can approve their own claims. This design ensures that the entity that issued the validation (e.g., OFFER-HUB, a DAO) maintains control over when to officially approve it.

---

### 4. `get_profile`

Query the profile of a specific account.

**Signature:**
```rust
pub fn get_profile(&self, account_id: AccountId) -> Option<Profile>
```

**Parameters:**
- `account_id`: Account to query

**Returns:**
- `Some(Profile)`: Profile data if it exists
- `None`: If no profile is registered

**Example Usage:**
```rust
let profile = contract.get_profile(alice_address);
if let Some(p) = profile {
    println!("Profile URI: {}", p.metadata_uri);
}
```

**JSON-RPC Call:**
```json
{
  "method": "get_profile",
  "params": ["5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"]
}
```

---

### 5. `get_claims`

Get all claims received by a specific account.

**Signature:**
```rust
pub fn get_claims(&self, account_id: AccountId) -> Vec<Claim>
```

**Parameters:**
- `account_id`: Account to query

**Returns:**
- `Vec<Claim>`: Vector of all claims (empty if none exist)

**Example Usage:**
```rust
let claims = contract.get_claims(bob_address);
for claim in claims {
    println!("Claim #{}: {} ({})", 
        claim.id, 
        claim.claim_type, 
        if claim.status == ClaimStatus::Approved { "Approved" } else { "Pending" }
    );
}
```

**JSON-RPC Call:**
```json
{
  "method": "get_claims",
  "params": ["5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"]
}
```

**Response Example:**
```json
[
  {
    "id": 0,
    "issuer": "5GrwvaEF...",
    "receiver": "5FHneW46...",
    "claim_type": "hackathon_win",
    "proof_hash": "0x1234...",
    "status": "Approved"
  },
  {
    "id": 1,
    "issuer": "5DAAnrj7...",
    "receiver": "5FHneW46...",
    "claim_type": "job_completed",
    "proof_hash": "0x5678...",
    "status": "Pending"
  }
]
```

---

## Events

### ProfileRegistered

Emitted when a new profile is registered.

```rust
#[ink(event)]
pub struct ProfileRegistered {
    #[ink(topic)]
    pub owner: AccountId,
    pub metadata_uri: String,
}
```

### ClaimAdded

Emitted when a new claim is issued.

```rust
#[ink(event)]
pub struct ClaimAdded {
    #[ink(topic)]
    pub claim_id: u64,
    #[ink(topic)]
    pub issuer: AccountId,
    #[ink(topic)]
    pub receiver: AccountId,
    pub claim_type: String,
}
```

### ClaimApproved

Emitted when a claim is approved.

```rust
#[ink(event)]
pub struct ClaimApproved {
    #[ink(topic)]
    pub claim_id: u64,
}
```

**Note:** Fields marked with `#[ink(topic)]` are indexed and can be efficiently queried by off-chain indexers.

---

## Error Handling

### ContractError Enum

```rust
pub enum ContractError {
    ProfileAlreadyExists,
    ProfileNotFound,
    ClaimNotFound,
    UnauthorizedApproval,
    ClaimAlreadyApproved,
}
```

**Error Descriptions:**

| Error | Description | Triggered By |
|-------|-------------|--------------|
| `ProfileAlreadyExists` | Account already has a registered profile | `register_profile` |
| `ProfileNotFound` | No profile found for the specified account | (reserved for future use) |
| `ClaimNotFound` | Claim ID doesn't exist | `approve_claim` |
| `UnauthorizedApproval` | Only issuer can approve their claim | `approve_claim` |
| `ClaimAlreadyApproved` | Claim has already been approved | `approve_claim` |

All public functions that can fail return `Result<T, ContractError>` for proper error handling.

---

## Storage Design

### Storage Structure

```rust
#[ink(storage)]
pub struct SkillChainRegistry {
    profiles: Mapping<AccountId, Profile>,
    claims: Mapping<u64, Claim>,
    next_claim_id: u64,
    user_claims: Mapping<AccountId, Vec<u64>>,
}
```

**Storage Fields:**

1. **profiles**: Maps each `AccountId` to their `Profile`
   - Allows O(1) lookup of user profiles
   - One profile per account

2. **claims**: Maps each claim ID to its `Claim` data
   - Enables efficient claim retrieval by ID
   - Claims are indexed by sequential IDs

3. **next_claim_id**: Counter for generating unique claim IDs
   - Increments on each new claim
   - Ensures globally unique claim identifiers

4. **user_claims**: Maps each `AccountId` to a vector of claim IDs
   - Stores all claim IDs received by a user
   - Enables efficient querying of all claims for an account

**Storage Complexity:**
- Profile lookup: O(1)
- Claim lookup: O(1)
- Get all claims for user: O(n) where n = number of claims for that user

---

## Compilation Instructions

### Prerequisites

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add wasm target
rustup component add rust-src
rustup target add wasm32-unknown-unknown

# Install cargo-contract
cargo install cargo-contract --force
```

### Build the Contract

```bash
cd contracts/skillchain

# Build release version
cargo contract build --release

# Or use the build script
./build.sh
```

**Build Artifacts:**

The compiled contract will be in `target/ink/`:
- `skillchain.contract` - Complete contract bundle (code + metadata)
- `skillchain.wasm` - Contract WASM bytecode
- `metadata.json` - Contract ABI

### Check Contract Size

```bash
ls -lh target/ink/skillchain.wasm
```

Optimized contracts should be under 100KB for efficient deployment.

---

## Testing Instructions

### Unit Tests

Run all unit tests:

```bash
cd contracts/skillchain
cargo test
```

Run specific test:

```bash
cargo test test_register_profile_success
```

Run with output:

```bash
cargo test -- --nocapture
```

### Test Coverage

The contract includes 13+ unit tests covering:

- ✅ Profile registration (success and duplicate)
- ✅ Claim addition (success and ID increment)
- ✅ Claim approval (by issuer, unauthorized, double approval)
- ✅ Profile retrieval (existing and non-existent)
- ✅ Claims retrieval (empty and multiple)
- ✅ Error cases (not found, unauthorized)

### E2E Tests

Run end-to-end tests (requires running node):

```bash
cargo test --features e2e-tests
```

---

## Deployment Guide

### Deploy to Local Node

#### 1. Start Local Node

```bash
# Using substrate-contracts-node
substrate-contracts-node --dev --tmp

# Or using Pop CLI
pop up parachain
```

#### 2. Upload and Deploy

**Using Polkadot.js Apps UI:**

1. Navigate to: https://polkadot.js.org/apps/?rpc=ws://127.0.0.1:9944#/contracts
2. Click "Upload & deploy code"
3. Upload `skillchain.contract` file
4. Select constructor: `new()`
5. Click "Deploy"
6. Sign with Alice account
7. Copy the contract address

**Using cargo-contract CLI:**

```bash
# Upload code
cargo contract upload \
  --suri //Alice \
  --execute

# Instantiate contract
cargo contract instantiate \
  --suri //Alice \
  --constructor new \
  --execute
```

### Deploy to Testnet (Paseo)

```bash
# Build for production
cargo contract build --release

# Upload to Paseo
cargo contract upload \
  --url wss://paseo.rpc.endpoint \
  --suri "your mnemonic phrase here" \
  --execute

# Instantiate
cargo contract instantiate \
  --url wss://paseo.rpc.endpoint \
  --suri "your mnemonic phrase here" \
  --constructor new \
  --execute
```

**Important:** Save the deployed contract address for frontend integration.

---

## Usage Examples

### Complete Workflow

#### 1. Register Profile

```rust
// Alice registers her profile
contract.register_profile("ipfs://QmAliceProfile".to_string())?;
```

#### 2. Issue Claim

```rust
// OFFER-HUB issues a claim to Alice for completing a job
let claim_id = contract.add_claim(
    alice_address,
    "job_completed".to_string(),
    Hash::from_slice(b"proof_hash_of_completed_job_12345")
)?;
// Returns: 0 (first claim ID)
```

#### 3. Approve Claim

```rust
// OFFER-HUB approves the claim (caller must be the issuer)
contract.approve_claim(0)?;
```

#### 4. Query Reputation

```rust
// Anyone can query Alice's claims
let claims = contract.get_claims(alice_address);

for claim in claims {
    println!(
        "Claim #{}: {} - {} by {:?}",
        claim.id,
        claim.claim_type,
        match claim.status {
            ClaimStatus::Approved => "Approved",
            ClaimStatus::Pending => "Pending",
        },
        claim.issuer
    );
}
```

### Integration Example (TypeScript)

```typescript
import { ApiPromise, WsProvider } from '@polkadot/api';
import { ContractPromise } from '@polkadot/api-contract';

// Connect to node
const wsProvider = new WsProvider('ws://127.0.0.1:9944');
const api = await ApiPromise.create({ provider: wsProvider });

// Load contract
const contract = new ContractPromise(
  api,
  contractAbi,
  contractAddress
);

// Register profile
const { gasRequired, result } = await contract.tx.registerProfile(
  { value: 0, gasLimit: -1 },
  'ipfs://QmMyProfile'
).signAndSend(alice);

// Query claims
const { output } = await contract.query.getClaims(
  alice.address,
  { value: 0, gasLimit: -1 },
  bobAddress
);
console.log('Claims:', output.toHuman());
```

---

## Security Considerations

### Access Control

- **Profile Registration**: Only account owner can register their profile
- **Claim Approval**: Only the issuer can approve their own claims
- **Public Queries**: Anyone can read profiles and claims (transparency)

### Validation

- Duplicate profile prevention
- Claim ID uniqueness
- Authorization checks on approval
- Status validation (can't approve twice)

### Best Practices

1. **Off-chain Data**: Store large metadata off-chain (IPFS/Arweave)
2. **Proof Hashes**: Use cryptographic hashes for proof verification
3. **Event Indexing**: Use indexed events for efficient querying
4. **Error Handling**: All mutable functions return `Result<T, ContractError>`

---

## Gas Optimization

The contract is optimized for gas efficiency:

- Uses `Mapping` for O(1) lookups
- Minimal storage writes
- Efficient event emission
- No unnecessary clones or allocations

**Estimated Gas Costs** (approximate):

| Operation | Gas Cost |
|-----------|----------|
| `register_profile` | ~50K |
| `add_claim` | ~60K |
| `approve_claim` | ~40K |
| `get_profile` | ~10K (read) |
| `get_claims` | ~20K + (n * 5K) |

---

## Future Enhancements

Potential improvements for future versions:

1. **Claim Expiration**: Time-limited claims
2. **Claim Revocation**: Ability to revoke approved claims
3. **Multi-Sig Approval**: Multiple approvers for claims
4. **Reputation Score**: Calculated score based on approved claims
5. **Claim Categories**: Structured claim taxonomy
6. **NFT Badges**: Mint NFTs for significant achievements
7. **Delegated Approval**: Allow receivers to approve on behalf of issuers

---

## Support & Resources

- **ink! Documentation**: https://use.ink
- **Polkadot.js Docs**: https://polkadot.js.org/docs/
- **Substrate Docs**: https://docs.substrate.io
- **Contract GitHub**: https://github.com/your-org/skillchain

---

## License

MIT License - See LICENSE file for details.

---

**Document Version:** 1.0  
**Last Updated:** November 2025  
**Contract Version:** 0.1.0

