# SkillChain Documentation

Welcome to the SkillChain protocol documentation.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Smart Contract](#smart-contract)
3. [SDK Integration](#sdk-integration)
4. [Frontend Application](#frontend-application)
5. [Deployment Guide](#deployment-guide)
6. [Development Setup](#development-setup)

## Architecture Overview

SkillChain is a decentralized professional reputation protocol built on Polkadot. The architecture consists of three main components:

### Components

```
┌─────────────────┐
│   Frontend App  │  Next.js 14 + TypeScript
└────────┬────────┘
         │
         ├─────────────────┐
         │                 │
┌────────▼─────────┐  ┌───▼──────────┐
│   SkillChain SDK │  │   Wallets    │
└────────┬─────────┘  └──────────────┘
         │              (Polkadot.js,
         │               Talisman,
         │               SubWallet)
┌────────▼─────────┐
│  ink! Contract   │  SkillChainRegistry
└──────────────────┘
         │
┌────────▼─────────┐
│   Polkadot       │  Parachain / Testnet
└──────────────────┘
```

### Data Flow

1. **User connects wallet** → Frontend → Polkadot Extension
2. **Create profile** → SDK → Contract → Blockchain
3. **Issue claim** → SDK → Contract → Blockchain
4. **Approve claim** → SDK → Contract → Blockchain
5. **Query reputation** → SDK → Contract → Display

## Smart Contract

### Contract: SkillChainRegistry

Location: `contracts/skillchain/`

#### Core Functions

- `register_profile(metadata_uri: String)` - Register a new user profile
- `add_claim(receiver: AccountId, claim_type: ClaimType, proof_hash: Hash)` - Issue a new claim
- `approve_claim(claim_id: u64)` - Approve an existing claim
- `get_claims(address: AccountId)` - Query all claims for an address
- `get_profile(address: AccountId)` - Get profile information

#### Data Structures

**Profile**
```rust
pub struct Profile {
    pub owner: AccountId,
    pub metadata_uri: String,
    pub created_at: u64,
}
```

**Claim**
```rust
pub struct Claim {
    pub id: u64,
    pub issuer: AccountId,
    pub receiver: AccountId,
    pub claim_type: ClaimType,
    pub proof_hash: Hash,
    pub approved: bool,
    pub timestamp: u64,
}
```

**ClaimType**
```rust
pub enum ClaimType {
    JobCompleted,
    HackathonWin,
    RepoContribution,
    SkillEndorsement,
    Other,
}
```

### Building the Contract

```bash
cd contracts/skillchain
./build.sh
```

Or manually:

```bash
cargo contract build --release
```

### Testing the Contract

```bash
cargo test
```

## SDK Integration

The TypeScript SDK provides a simple interface for integrating SkillChain into any application.

Location: `sdk/js/`

### Installation

```bash
npm install @skillchain/sdk
```

### Quick Start

```typescript
import { SkillChainClient, ClaimType } from '@skillchain/sdk';
import { ApiPromise, WsProvider } from '@polkadot/api';

// Connect to node
const api = await ApiPromise.create({
  provider: new WsProvider('ws://127.0.0.1:9944')
});

// Initialize client
const client = new SkillChainClient({
  api,
  contractAddress: 'CONTRACT_ADDRESS',
  abi: contractAbi,
});

// Create profile
await client.createProfile(
  { metadataUri: 'ipfs://...' },
  signerAddress
);

// Add claim
await client.addClaim(
  {
    receiver: 'ACCOUNT_ID',
    claimType: ClaimType.JobCompleted,
    proofHash: '0x...',
  },
  signerAddress
);
```

See [SDK README](../sdk/js/README.md) for full API reference.

## Frontend Application

Location: `app/web/`

Built with Next.js 14, TypeScript, and TailwindCSS.

### Features

- Wallet connection (Polkadot.js, Talisman, SubWallet)
- Profile creation and management
- Claim issuance and approval
- Reputation dashboard
- Responsive design

### Project Structure

```
app/web/src/
├── components/    # React components (presentation)
├── hooks/         # Custom hooks (business logic)
├── pages/         # Next.js pages (orchestration)
├── types/         # TypeScript definitions
└── styles/        # Global styles
```

### Running Locally

```bash
cd app/web
npm install
npm run dev
```

Open http://localhost:3000

## Deployment Guide

### 1. Deploy Smart Contract

#### Using cargo-contract

```bash
cd contracts/skillchain
cargo contract build --release
cargo contract upload --suri //Alice
cargo contract instantiate \
  --suri //Alice \
  --constructor new \
  --args
```

#### Using Pop CLI

```bash
pop up contract --constructor new
```

### 2. Deploy Frontend

#### Vercel

```bash
cd app/web
vercel deploy
```

#### Self-hosted

```bash
npm run build
npm start
```

### 3. Publish SDK

```bash
cd sdk/js
npm publish
```

## Development Setup

### Prerequisites

- Rust (latest stable)
- Node.js v18+
- cargo-contract
- Pop CLI (optional)

### Install Rust & cargo-contract

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-src
cargo install cargo-contract --force
```

### Install Node Dependencies

```bash
# Frontend
cd app/web
npm install

# SDK
cd ../../sdk/js
npm install
```

### Running Local Node

#### Using Substrate Contracts Node

```bash
substrate-contracts-node --dev
```

#### Using Pop CLI

```bash
pop up parachain -f ./network.toml
```

### Testing Full Stack

1. Start local node
2. Build and deploy contract
3. Update frontend with contract address
4. Run frontend dev server
5. Connect wallet and test features

## Network Configurations

### Local Development

- Node: `ws://127.0.0.1:9944`
- Explorer: https://polkadot.js.org/apps/?rpc=ws://127.0.0.1:9944

### Paseo Testnet

- Node: `wss://paseo.rpc.endpoint`
- Faucet: [Get test tokens]
- Explorer: https://polkadot.js.org/apps/?rpc=wss://paseo...

## Resources

- [ink! Documentation](https://use.ink)
- [Polkadot.js Documentation](https://polkadot.js.org/docs/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Substrate Documentation](https://docs.substrate.io)

## Support

For questions or issues:
- Open an issue on GitHub
- Contact the team via Discord/Telegram
- Check the FAQ section

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

MIT

