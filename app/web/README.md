# SkillChain Web Frontend

Next.js 14 frontend application for the SkillChain protocol.

## Getting Started

### Install dependencies

```bash
npm install
```

### Run development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
src/
├── components/    # React components (presentation only)
├── hooks/         # Custom hooks (business logic)
├── pages/         # Next.js pages (orchestration)
├── types/         # TypeScript type definitions
└── styles/        # Global styles
```

## Development Guidelines

- **Components**: Presentation only, no business logic
- **Hooks**: All business logic goes in custom hooks
- **Types**: Shared types defined in `/src/types/`
- **Pages**: Orchestrate components and hooks only

## Tech Stack

- Next.js 14
- TypeScript
- TailwindCSS
- @polkadot/api
- @polkadot/extension-dapp

## Wallet Support

- Polkadot.js Extension
- Talisman
- SubWallet

