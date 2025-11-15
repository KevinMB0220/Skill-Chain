# SkillChain — On-Chain Professional Reputation Protocol

**SkillChain** is a decentralized professional reputation protocol built on Polkadot, enabling freelancers, developers, and Web3 contributors to register, verify, and publicly showcase validated achievements on-chain.

## 🎯 Overview

This protocol is implemented as an **ink! smart contract** deployed on a WASM-compatible parachain. Validations (e.g., "completed a job", "won a hackathon", "contributed to a repo") are registered as claims that can be approved on-chain by another entity (e.g., a client, a DAO, or OFFER-HUB).

**OFFER-HUB**, a Web3 freelance platform, is the first official integrator of the protocol, consuming and integrating SkillChain public profiles within its app to display each freelancer's validated history.

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

4. **Deploy the contract:**

```bash
# Local node
./deploy.sh local

# Testnet (Paseo)
./deploy.sh paseo "your seed phrase"
```

See [DEPLOYMENT.md](contracts/skillchain/DEPLOYMENT.md) for detailed instructions.

5. **Run the frontend:**

```bash
cd app/web
npm run dev
```

## 📦 Components

### Smart Contract (`contracts/skillchain/`)

The `SkillChainRegistry` contract provides:
- `register_profile(address, metadata_uri)`
- `add_claim(issuer, receiver, claim_type, proof_hash)`
- `approve_claim(claim_id)`
- `get_claims(address)`

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

## 🛠️ Tech Stack

- **Smart Contracts:** Rust, ink! v4+
- **Frontend:** Next.js 14, TypeScript, TailwindCSS
- **Blockchain:** Polkadot, @polkadot/api
- **Wallets:** Polkadot.js Extension, Talisman, SubWallet

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

