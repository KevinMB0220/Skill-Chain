# SkillChain — On-Chain Professional Reputation Protocol

**SkillChain** is a decentralized professional reputation protocol built on Polkadot, enabling freelancers, developers, and Web3 contributors to register, verify, and publicly showcase validated achievements on-chain. By combining on-chain reputation with decentralized identity through KILT Protocol, SkillChain creates a powerful, portable, and verifiable professional identity system.

## 🎯 Overview

SkillChain is implemented as an **ink! smart contract** deployed on a WASM-compatible parachain. The protocol allows users to:

- **Register Professional Profiles**: Create on-chain profiles that serve as public, verifiable professional identities
- **Issue and Verify Claims**: Register achievements, work completions, and contributions as claims that can be approved by issuers (clients, DAOs, organizations)
- **Link Decentralized Identity**: Connect KILT DIDs (Decentralized Identifiers) to profiles for portable, wallet-independent identity
- **Showcase Reputation**: Display validated history and achievements publicly on-chain

Validations (e.g., "completed a job", "won a hackathon", "contributed to a repo") are registered as claims that can be approved on-chain by another entity (e.g., a client, a DAO, or OFFER-HUB). Each claim includes proof hashes stored off-chain (on IPFS, Arweave, or Arkiv) and can be verified by anyone.

### Built on Polkadot

SkillChain leverages the **Polkadot ecosystem** to provide a decentralized, interoperable reputation system. By deploying on a WASM-compatible parachain, the protocol benefits from:

- **Fast Finality**: Sub-second block times on optimized parachains
- **Low Transaction Costs**: Efficient gas usage with ink! smart contracts
- **Cross-Chain Interoperability**: Native integration with other Polkadot parachains
- **Scalability**: Parachain architecture allows for high throughput
- **Security**: Shared security model through Polkadot's relay chain

The protocol integrates seamlessly with Polkadot's native technologies:
- **ink! 5.0** for smart contract development
- **Substrate** for blockchain infrastructure
- **KILT Protocol** for decentralized identity (native Polkadot parachain)
- **Polkadot.js** for wallet integration and user experience

**OFFER-HUB**, a Web3 freelance platform, is the first official integrator of the protocol, consuming and integrating SkillChain public profiles within its app to display each freelancer's validated history.

### The Power of KILT + SkillChain Integration

SkillChain and KILT Protocol work together to create a more powerful, portable, and user-centric reputation system than either could achieve alone:

#### 🔐 **Portable Identity with KILT DIDs**

**The Problem**: Traditional blockchain-based reputation systems tie identity to wallet addresses. If a user loses their wallet or wants to switch wallets, they lose their entire reputation history.

**The Solution**: SkillChain profiles can be linked to KILT DIDs (Decentralized Identifiers). A KILT DID is a portable identity that:
- **Persists across wallets**: Users can change blockchain accounts without losing their identity
- **Works across chains**: DIDs are chain-agnostic and can be used across different Polkadot parachains
- **User-controlled**: Users own and control their DID, not tied to any single service or wallet

#### ✅ **Verifiable Credentials for Enhanced Trust**

**KILT's Role**: KILT Protocol enables the creation and verification of Verifiable Credentials (VCs) - cryptographically signed attestations about a user's attributes, achievements, or qualifications.

**SkillChain's Role**: SkillChain stores on-chain claims and reputation data that can reference and validate KILT credentials.

**Together They Enable**:
- **Credential Verification**: Users can present KILT credentials (e.g., "Certified Developer", "University Degree") that are cryptographically verified
- **On-Chain Reputation**: SkillChain stores work history, client approvals, and project completions as immutable on-chain claims
- **Combined Trust**: A freelancer's profile shows both verified credentials (from KILT) and validated work history (from SkillChain)

#### 🌐 **Interoperability Across the Polkadot Ecosystem**

Both protocols are native to Polkadot, enabling seamless integration:

- **KILT Parachain**: Provides identity infrastructure as a dedicated parachain
- **SkillChain Contract**: Deployed on any WASM-compatible parachain, can reference KILT DIDs
- **Cross-Chain Identity**: A DID created on KILT can be used across multiple parachains where SkillChain is deployed

#### 💼 **Real-World Use Case: Offer-Hub**

In Offer-Hub, the integration works as follows:

1. **User Creates KILT Identity**: Freelancer creates a Light DID using KILT Protocol
2. **Links to SkillChain Profile**: The DID is linked to their SkillChain profile on-chain
3. **Builds Reputation**: As they complete jobs, clients issue claims on SkillChain
4. **Presents Credentials**: They can present KILT credentials (certifications, education) alongside their work history
5. **Portable Identity**: If they switch wallets or chains, their DID remains the same, and their SkillChain profile can be re-linked

This creates a **self-sovereign professional identity** that is:
- ✅ **Portable**: Not tied to a single wallet or chain
- ✅ **Verifiable**: Cryptographically provable credentials and claims
- ✅ **Persistent**: Survives wallet changes and chain migrations
- ✅ **Comprehensive**: Combines verified credentials with validated work history

### About Offer-Hub

**Offer-Hub** is a decentralized freelance platform that democratizes global financial access using the Polkadot blockchain as its infrastructure. Built on top of SkillChain and integrated with KILT Protocol, it provides:

- **Universal Financial Inclusion**: Enables freelancers worldwide to receive and send payments instantly, with simple wallet creation through Polkadot.js Extension — no KYC friction or bank checks required.

- **Instant Democratic Payments**: Fast transaction processing on Polkadot parachains with milestone-based escrow payments. The platform returns economic power directly to freelancers by removing intermediaries through smart contract automation.

- **Transparent Dispute Resolution**: Conflict resolution via community voting and designated arbiters. Smart contracts automatically execute decisions, eliminating bias and delay compared to opaque centralized systems.

- **Portable Professional Identity**: Freelancers can build a reputation that follows them across wallets and chains, thanks to KILT DID integration with SkillChain profiles.

The platform leverages:
- **SkillChain Protocol** for on-chain reputation and verified achievements
- **Escrow Multi-Release Contract** for secure milestone-based payments
- **KILT Protocol** for decentralized identity (DIDs and Verifiable Credentials)
- **Polkadot Ecosystem** for fast, low-cost transactions

**How It Works Together**:
1. Freelancers create a KILT Light DID for portable identity
2. Link the DID to their SkillChain profile to establish on-chain reputation
3. Complete jobs and receive claims from clients (stored on SkillChain)
4. Present verified credentials (from KILT) alongside work history (from SkillChain)
5. Use the combined reputation to secure new opportunities on Offer-Hub

## 🏗️ Project Structure

```
offerhub-skillchain/
├── contracts/skillchain/    # ink! smart contract
├── sdk/js/                  # TypeScript SDK for integrations
├── app/web/                 # Next.js frontend application
├── docs/                    # Technical documentation
├── .gitignore
├── LICENSE
├── README.md
└── pop.toml
```

## 🚀 Getting Started

### Prerequisites

- **Rust** (latest stable) with `wasm32-unknown-unknown` target
- **cargo-contract** CLI
- **Node.js** v18+ and npm/yarn/pnpm
- **Pop CLI** (optional, for contract development)

### Setup

1. **Install Rust and cargo-contract:**

```bash
rustup component add rust-src
cargo install cargo-contract --force
```

2. **Install dependencies:**

```bash
# Frontend
cd app/web
npm install

# SDK
cd ../../sdk/js
npm install
```

3. **Build the smart contract:**

```bash
cd contracts/skillchain
cargo contract build --release
```

**✅ Contract compiled successfully!**
- Size: 12.9KB (optimized)
- Artifacts: `target/ink/skillchain.contract`

4. **Local one-liner (node + deploy both contracts)**

```bash
bash contracts/deploy-local-all.sh
```

This will:
- Restart a local contracts node (`ws://127.0.0.1:9944`)
- Build and deploy SkillChain and Escrow
- Print .env-ready lines with both addresses

5. **Deploy the contract (manual alternative):**

```bash
# Local node
./deploy.sh local

# Testnet (Paseo)
./deploy.sh paseo "your seed phrase"
```

For a concise local guide, see `contracts/skillchain/deployment-local.md`. For quick steps, see `contracts/how-deploy.md`.

5. **Run the frontend:**

```bash
cd app/web
npm run dev
```

## 📦 Components

### Smart Contracts

#### SkillChain Registry (`contracts/skillchain/`)

The `SkillChainRegistry` contract provides:
- `register_profile(address, metadata_uri)`
- `add_claim(issuer, receiver, claim_type, proof_hash)`
- `approve_claim(claim_id)`
- `get_claims(address)`
- `link_did(did: String)` - Link KILT DID to profile
- `get_did(account_id)` - Get linked DID from profile

#### Escrow Multi-Release (`contracts/escrow/`)

The `EscrowMultiRelease` contract enables secure freelance payments:
- `create_escrow(freelancer, milestones, arbiter)` - Create milestone-based escrow
- `fund_escrow(escrow_id)` - Lock funds in escrow
- `release_milestone(escrow_id, milestone_id)` - Release payment for completed milestone
- `request_cancel(escrow_id)` - Request cancellation
- `approve_cancel(escrow_id)` - Approve mutual cancellation
- `resolve_dispute_by_arbiter(escrow_id, decision)` - Arbiter resolves disputes

### Frontend (`app/web/`)

Next.js 14 application with:
- Wallet connection (Polkadot.js, Talisman, SubWallet)
- On-chain profile creation
- Achievement visualization
- Claim issuance and approval

### SDK (`sdk/js/`)

TypeScript SDK for external integrations with functions:
- `createProfile()`
- `addClaim()`
- `approveClaim()`
- `getClaimsByAddress()`
- `linkDid()` - Link KILT DID to profile
- `getDid()` - Get linked DID from profile

**KILT Integration:**
- `KiltClient` - Full client for KILT Protocol interactions
- `createLightDid()` - Generate KILT Light DID (portable identity)
- `linkDidToProfile()` - Link KILT DID to SkillChain profile
- `verifyCredential()` - Verify KILT Verifiable Credentials
- `resolveDid()` - Resolve DID documents from KILT network
- `getDidFromAccount()` - Retrieve linked DID from SkillChain profile

## 🛠️ Tech Stack

### Web3 Technologies
- **ink!** - Smart contracts (v5.0) for WASM-compatible parachains
- **Substrate** - Blockchain framework
- **Polkadot** - Multi-chain network
- **KILT Protocol** - Decentralized Identity (DIDs and Verifiable Credentials)
- **Arkiv** - Decentralized storage protocol (planned integration)

### Development Stack
- **Smart Contracts:** Rust, ink! 5.0, cargo-contract
- **Frontend:** Next.js 14, TypeScript, TailwindCSS
- **SDK:** TypeScript, @polkadot/api, @polkadot/api-contract
- **Wallets:** Polkadot.js Extension, Talisman, SubWallet
- **Testing:** Jest, ink_e2e

## 🎯 Hackathon

Developed for **Sub0 Hackathon** (Polkadot):
- Polkadot Main Track
- Hyperbridge SDK bounty
- Marketing Track (GTM + adoption)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📬 Contact

For questions or collaboration opportunities, please open an issue or reach out to the OFFER-HUB team.

