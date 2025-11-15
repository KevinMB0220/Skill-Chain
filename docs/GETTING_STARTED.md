# Getting Started with SkillChain

This guide will help you set up and run SkillChain locally for development.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Rust** (latest stable version)
- **Node.js** v18 or higher
- **npm** or **yarn**
- **cargo-contract** CLI tool

## Installation

### 1. Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

After installation, add the wasm target:

```bash
rustup component add rust-src
rustup target add wasm32-unknown-unknown
```

### 2. Install cargo-contract

```bash
cargo install cargo-contract --force
```

Verify installation:

```bash
cargo contract --version
```

### 3. Install Node.js Dependencies

```bash
# Install frontend dependencies
cd app/web
npm install

# Install SDK dependencies
cd ../../sdk/js
npm install
```

## Running Locally

### Step 1: Start a Local Blockchain Node

You have two options:

#### Option A: Substrate Contracts Node (Recommended for Development)

```bash
# Install substrate-contracts-node
cargo install contracts-node --git https://github.com/paritytech/substrate-contracts-node.git

# Run the node
substrate-contracts-node --dev --tmp
```

#### Option B: Pop CLI

```bash
# Install Pop CLI
cargo install --git https://github.com/r0gue-io/pop-cli

# Run local parachain
pop up parachain
```

Your node should now be running at `ws://127.0.0.1:9944`

### Step 2: Build the Smart Contract

```bash
cd contracts/skillchain
./build.sh
```

Or manually:

```bash
cargo contract build --release
```

The build artifacts will be in `target/ink/`:
- `skillchain.contract` - Complete contract bundle
- `skillchain.wasm` - Contract WASM code
- `metadata.json` - Contract ABI

### Step 3: Deploy the Contract

#### Using Polkadot.js Apps UI

1. Open [Polkadot.js Apps](https://polkadot.js.org/apps/?rpc=ws://127.0.0.1:9944#/contracts)
2. Navigate to Developer → Contracts
3. Click "Upload & deploy code"
4. Upload `skillchain.contract` file
5. Click "Next"
6. Select constructor: `new()`
7. Click "Deploy"
8. Sign transaction with Alice account
9. Copy the deployed contract address

#### Using cargo-contract CLI

```bash
# Upload code
cargo contract upload --suri //Alice

# Instantiate contract
cargo contract instantiate \
  --suri //Alice \
  --constructor new \
  --args
```

### Step 4: Configure the Frontend

Create a configuration file at `app/web/.env.local`:

```env
NEXT_PUBLIC_WS_PROVIDER=ws://127.0.0.1:9944
NEXT_PUBLIC_CONTRACT_ADDRESS=YOUR_CONTRACT_ADDRESS_HERE
```

Replace `YOUR_CONTRACT_ADDRESS_HERE` with the deployed contract address from Step 3.

### Step 5: Run the Frontend

```bash
cd app/web
npm run dev
```

Open your browser and navigate to [http://localhost:3000](http://localhost:3000)

### Step 6: Connect Your Wallet

1. Install [Polkadot.js Extension](https://polkadot.js.org/extension/)
2. Create or import an account
3. Click "Connect Wallet" in the SkillChain app
4. Approve the connection

## Testing the Full Flow

### 1. Create a Profile

```typescript
// In browser console or test script
await client.createProfile(
  { metadataUri: 'ipfs://QmExample...' },
  signerAddress
);
```

### 2. Issue a Claim

```typescript
await client.addClaim(
  {
    receiver: '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY',
    claimType: ClaimType.JobCompleted,
    proofHash: '0x1234567890abcdef...',
  },
  signerAddress
);
```

### 3. Approve a Claim

```typescript
await client.approveClaim(
  { claimId: 1 },
  receiverAddress
);
```

### 4. Query Claims

```typescript
const claims = await client.getClaimsByAddress(address);
console.log(claims);
```

## Development Workflow

### Making Contract Changes

1. Edit `contracts/skillchain/lib.rs`
2. Rebuild: `./build.sh`
3. Redeploy contract
4. Update contract address in frontend
5. Test changes

### Making Frontend Changes

1. Edit files in `app/web/src/`
2. Changes auto-reload with `npm run dev`
3. Test in browser

### Making SDK Changes

1. Edit files in `sdk/js/src/`
2. Rebuild: `npm run build`
3. Test in frontend or test script

## Troubleshooting

### Contract Build Fails

```bash
# Update rust and cargo-contract
rustup update
cargo install cargo-contract --force

# Clean and rebuild
cargo clean
cargo contract build --release
```

### Frontend Can't Connect to Node

- Verify node is running: `ws://127.0.0.1:9944`
- Check `.env.local` has correct WS_PROVIDER
- Ensure browser allows WebSocket connections

### Wallet Connection Issues

- Install Polkadot.js Extension
- Ensure extension is unlocked
- Check that accounts are visible
- Try refreshing the page

### Transaction Fails

- Ensure account has sufficient balance
- Check that contract address is correct
- Verify function parameters are valid
- Look for errors in browser console

## Next Steps

- Read the [Architecture Documentation](./ARCHITECTURE.md)
- Explore the [SDK Documentation](../sdk/js/README.md)
- Check out example integrations
- Deploy to Paseo testnet

## Resources

- [ink! Documentation](https://use.ink)
- [Polkadot.js API Docs](https://polkadot.js.org/docs/)
- [Substrate Contracts Tutorial](https://docs.substrate.io/tutorials/smart-contracts/)
- [Next.js Documentation](https://nextjs.org/docs)

## Support

If you encounter issues:
- Check the [troubleshooting section](#troubleshooting)
- Open an issue on GitHub
- Ask in the community Discord

