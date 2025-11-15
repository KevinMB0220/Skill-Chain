# SkillChain Architecture

## System Overview

SkillChain is a decentralized reputation protocol designed to provide verifiable, on-chain professional credentials for freelancers, developers, and Web3 contributors.

## Architecture Layers

### 1. Blockchain Layer (ink! Smart Contract)

**Component**: `SkillChainRegistry` contract

**Responsibilities**:
- Store user profiles on-chain
- Manage claims (achievements, endorsements, validations)
- Handle claim approvals
- Emit events for off-chain indexing

**Key Features**:
- Immutable storage of validated achievements
- Cryptographic proof of endorsements
- Transparent approval mechanism
- Public queryability

### 2. SDK Layer (TypeScript)

**Component**: `@skillchain/sdk`

**Responsibilities**:
- Abstract contract interaction complexity
- Provide type-safe API
- Handle transaction signing
- Parse contract responses

**Integration Points**:
- OFFER-HUB platform
- External dApps
- Analytics services
- Indexers

### 3. Application Layer (Next.js Frontend)

**Component**: Web application

**Responsibilities**:
- User interface for protocol interaction
- Wallet connection management
- Profile visualization
- Claim issuance and approval UI

**User Flows**:
1. Connect wallet → View profile
2. Create profile → Set metadata
3. Issue claim → Select type, add proof
4. Approve claim → Verify and sign
5. View reputation → Display achievements

## Data Models

### Profile

```rust
Profile {
  owner: AccountId,        // Wallet address
  metadata_uri: String,    // IPFS/Arweave URI
  created_at: u64,         // Timestamp
}
```

Metadata (off-chain):
```json
{
  "name": "John Doe",
  "bio": "Full-stack developer",
  "avatar": "ipfs://...",
  "links": {
    "github": "...",
    "twitter": "..."
  }
}
```

### Claim

```rust
Claim {
  id: u64,                  // Unique identifier
  issuer: AccountId,        // Who issued the claim
  receiver: AccountId,      // Who receives the claim
  claim_type: ClaimType,    // Type of achievement
  proof_hash: Hash,         // IPFS hash of proof
  approved: bool,           // Approval status
  timestamp: u64,           // Creation time
}
```

### ClaimType Enum

```rust
enum ClaimType {
  JobCompleted,        // Project/job completion
  HackathonWin,        // Hackathon victory
  RepoContribution,    // Code contribution
  SkillEndorsement,    // Skill validation
  Other,               // Custom claims
}
```

## State Management

### On-Chain State

- **Profiles Mapping**: `AccountId → Profile`
- **Claims Mapping**: `ClaimId → Claim`
- **User Claims**: `AccountId → Vec<ClaimId>`
- **Next Claim ID**: Counter for unique IDs

### Off-Chain State

- User sessions (wallet connection)
- UI state (React hooks)
- Cached queries (optional)

## Security Model

### Access Control

1. **Profile Creation**: Only owner can create their profile
2. **Claim Issuance**: Any account can issue claims to others
3. **Claim Approval**: Only receiver or authorized parties can approve
4. **Data Integrity**: All data cryptographically signed

### Trust Model

- Claims are public and transparent
- Approval mechanism prevents false claims
- Proof hashes provide verifiability
- On-chain history is immutable

## Scalability Considerations

### Current Design (MVP)

- Direct contract calls
- On-chain storage for all data
- Query-per-request model

### Future Optimizations

1. **Indexing Layer**: Off-chain indexer for fast queries
2. **Batch Operations**: Multiple claims in one transaction
3. **Layer 2**: Move heavy data to IPFS/Arweave
4. **Caching**: Client-side and CDN caching
5. **Cross-Chain**: Bridge to other parachains

## Integration Patterns

### Pattern 1: Direct SDK Integration

```typescript
// Integrate SkillChain into your app
import { SkillChainClient } from '@skillchain/sdk';

const client = new SkillChainClient(config);
const reputation = await client.getClaimsByAddress(userAddress);
```

### Pattern 2: Read-Only Display

```typescript
// Display SkillChain reputation without write access
const profile = await client.getProfile(address);
const claims = await client.getClaimsByAddress(address);
renderReputationBadge(claims);
```

### Pattern 3: Automated Issuance

```typescript
// Backend service issues claims automatically
async function onJobCompletion(freelancerId, jobId) {
  await client.addClaim({
    receiver: freelancerId,
    claimType: ClaimType.JobCompleted,
    proofHash: await uploadProof(jobId),
  });
}
```

## Event-Driven Architecture

### Contract Events

```rust
#[ink(event)]
pub struct ProfileRegistered {
    owner: AccountId,
    metadata_uri: String,
}

#[ink(event)]
pub struct ClaimAdded {
    claim_id: u64,
    issuer: AccountId,
    receiver: AccountId,
}

#[ink(event)]
pub struct ClaimApproved {
    claim_id: u64,
}
```

### Event Handling

1. Contract emits event
2. Indexer catches event
3. Database updated
4. Frontend notified (WebSocket/polling)
5. UI refreshed

## Technology Stack

### Smart Contract
- Language: Rust
- Framework: ink! v4+
- Target: WASM

### SDK
- Language: TypeScript
- Dependencies: @polkadot/api, @polkadot/api-contract
- Build: tsc

### Frontend
- Framework: Next.js 14
- Language: TypeScript
- Styling: TailwindCSS
- State: React Hooks

### Infrastructure
- Blockchain: Polkadot Parachain
- Storage: IPFS/Arweave (metadata)
- Hosting: Vercel/self-hosted

## Deployment Architecture

```
┌─────────────────────────────────────┐
│         CDN / Vercel                │
│   (Frontend Static Assets)          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       User's Browser                │
│  - React App                        │
│  - SkillChain SDK                   │
│  - Wallet Extension                 │
└──────────────┬──────────────────────┘
               │
               ├─────────────┬────────────┐
               │             │            │
┌──────────────▼──┐  ┌───────▼─────┐  ┌──▼────────────┐
│  RPC Endpoint   │  │   Indexer   │  │  IPFS Node    │
│  (Parachain)    │  │  (Optional) │  │  (Metadata)   │
└─────────────────┘  └─────────────┘  └───────────────┘
```

## Future Enhancements

1. **Reputation Scores**: Algorithm to calculate reputation from claims
2. **NFT Badges**: Mint NFTs for significant achievements
3. **Privacy Layer**: Zero-knowledge proofs for selective disclosure
4. **Cross-Chain**: Bridge reputation to other ecosystems
5. **Governance**: DAO for protocol upgrades
6. **Analytics**: Dashboard for reputation insights

## References

- [ink! Documentation](https://use.ink)
- [Polkadot Documentation](https://wiki.polkadot.network)
- [Substrate Contracts](https://docs.substrate.io/tutorials/smart-contracts/)

