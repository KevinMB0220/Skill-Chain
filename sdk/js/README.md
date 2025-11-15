# SkillChain SDK

TypeScript SDK for integrating with the SkillChain protocol.

## Installation

```bash
npm install @skillchain/sdk
```

## Usage

### Initialize the client

```typescript
import { SkillChainClient } from '@skillchain/sdk';
import { ApiPromise, WsProvider } from '@polkadot/api';

// Connect to Polkadot node
const wsProvider = new WsProvider('ws://127.0.0.1:9944');
const api = await ApiPromise.create({ provider: wsProvider });

// Initialize SkillChain client
const client = new SkillChainClient({
  api,
  contractAddress: 'YOUR_CONTRACT_ADDRESS',
  abi: contractAbi, // Import your contract ABI
});
```

### Create a profile

```typescript
const result = await client.createProfile(
  {
    metadataUri: 'ipfs://QmYourMetadataHash',
  },
  signerAddress
);
```

### Add a claim

```typescript
import { ClaimType } from '@skillchain/sdk';

const result = await client.addClaim(
  {
    receiver: '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY',
    claimType: ClaimType.JobCompleted,
    proofHash: '0x1234...',
  },
  signerAddress
);
```

### Approve a claim

```typescript
const result = await client.approveClaim(
  {
    claimId: 1,
  },
  signerAddress
);
```

### Query claims

```typescript
const claims = await client.getClaimsByAddress(
  '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY'
);
```

### Query profile

```typescript
const profile = await client.getProfile(
  '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY'
);
```

## API Reference

### SkillChainClient

Main client class for interacting with the SkillChain protocol.

#### Methods

- `createProfile(options, signerAddress)` - Create a new on-chain profile
- `addClaim(options, signerAddress)` - Add a new claim
- `approveClaim(options, signerAddress)` - Approve an existing claim
- `getClaimsByAddress(address)` - Get all claims for an address
- `getProfile(address)` - Get profile for an address
- `getTotalClaims()` - Get total number of claims in the system
- `disconnect()` - Cleanup and disconnect

### Types

See [types.ts](./src/types.ts) for all type definitions.

## Development

### Build

```bash
npm run build
```

### Watch mode

```bash
npm run watch
```

## License

MIT

