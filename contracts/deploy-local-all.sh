#!/usr/bin/env bash

# SkillChain + Escrow local deploy helper
# This script:
# 1) Starts a local contracts node (background)
# 2) Builds both contracts
# 3) Uploads + instantiates each
# 4) Prints .env-ready exports
#
# Requirements:
# - cargo-contract installed
# - contracts-node installed
# - macOS/Linux shell
#
# Usage:
#   bash contracts/deploy-local-all.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTRACTS_DIR="$ROOT_DIR/contracts"
WS_URL="ws://127.0.0.1:9944"
SURI="//Alice"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info () { echo -e "${BLUE}$*${NC}"; }
ok () { echo -e "${GREEN}$*${NC}"; }
warn () { echo -e "${YELLOW}$*${NC}"; }
err () { echo -e "${RED}$*${NC}"; }

# --- 0) Restart local node (fresh state) ---
info "Restarting local node (fresh --tmp state)..."
pkill -f "substrate-contracts-node --dev --tmp" >/dev/null 2>&1 || true
sleep 1
nohup substrate-contracts-node --dev --tmp >/tmp/contracts-node.log 2>&1 &
sleep 2
if ! pgrep -f "substrate-contracts-node --dev --tmp" >/dev/null 2>&1; then
  err "Failed to start local node. Check if 'substrate-contracts-node' is installed and logs at /tmp/contracts-node.log"
  exit 1
fi

# helper to build/upload/instantiate and extract address
deploy_contract () {
  local CONTRACT_NAME="$1"       # skillchain | escrow
  local REL_PATH="$2"            # contracts/skillchain | contracts/escrow
  local BUNDLE_NAME="$3"         # skillchain.contract | escrow.contract
  local ADDR_VAR="$4"            # SKILLCHAIN_ADDR | ESCROW_ADDR

  info "Building ${CONTRACT_NAME}..."
  cd "$ROOT_DIR/$REL_PATH"
  cargo contract build --release

  info "Uploading ${CONTRACT_NAME}..."
  set +e
  UPLOAD_OUTPUT=$(cargo contract upload \
    --suri "$SURI" \
    --url "$WS_URL" \
    --execute "target/ink/${BUNDLE_NAME}" -y 2>&1)
  local EXIT_CODE=$?
  set -e
  echo "$UPLOAD_OUTPUT"
  # Handle "already uploaded" as success: extract code hash and continue
  if echo "$UPLOAD_OUTPUT" | grep -qi "already been uploaded with code hash"; then
    warn "${CONTRACT_NAME} code already uploaded. Reusing existing code hash."
    CODE_HASH=$(echo "$UPLOAD_OUTPUT" | grep -oE "0x[a-fA-F0-9]{64}" | head -1 || true)
    EXIT_CODE=0
  fi
  if [[ $EXIT_CODE -ne 0 ]]; then
    err "Upload failed for ${CONTRACT_NAME}"
    exit 1
  fi
  CODE_HASH=$(echo "$UPLOAD_OUTPUT" | grep -oE "0x[a-fA-F0-9]{64}" | head -1 || true)
  if [[ -z "${CODE_HASH:-}" ]]; then
    warn "Could not auto-extract code hash for ${CONTRACT_NAME}. Continuing..."
  else
    ok "Code hash (${CONTRACT_NAME}): $CODE_HASH"
  fi

  info "Instantiating ${CONTRACT_NAME}..."
  set +e
  INSTANTIATE_OUTPUT=$(cargo contract instantiate \
    --suri "$SURI" \
    --url "$WS_URL" \
    --constructor new \
    --execute -y 2>&1)
  EXIT_CODE=$?
  set -e
  echo "$INSTANTIATE_OUTPUT"
  if [[ $EXIT_CODE -ne 0 ]]; then
    err "Instantiation failed for ${CONTRACT_NAME}"
    exit 1
  fi

  CONTRACT_ADDR=$(echo "$INSTANTIATE_OUTPUT" | grep -oE "Contract [1-9A-HJ-NP-Za-km-z]{47,50}" | awk '{print $2}' | tail -1 || true)
  if [[ -z "${CONTRACT_ADDR:-}" ]]; then
    # fallback to parse 'account:' when shown
    CONTRACT_ADDR=$(echo "$INSTANTIATE_OUTPUT" | grep -oE "contract: [1-9A-HJ-NP-Za-km-z]{47,50}" | awk '{print $2}' | tail -1 || true)
  fi
  if [[ -z "${CONTRACT_ADDR:-}" ]]; then
    err "Could not extract contract address for ${CONTRACT_NAME}"
    exit 1
  fi
  ok "${CONTRACT_NAME} Address: ${CONTRACT_ADDR}"
  eval "${ADDR_VAR}=${CONTRACT_ADDR}"
}

# --- 1) Deploy SkillChain ---
deploy_contract "SkillChain" "contracts/skillchain" "skillchain.contract" "SKILLCHAIN_ADDR"

# --- 2) Deploy Escrow ---
deploy_contract "Escrow" "contracts/escrow" "escrow.contract" "ESCROW_ADDR"

# --- 3) Print .env-ready outputs ---
echo ""
ok "All done! Add these to your frontend .env.local:"
echo "NEXT_PUBLIC_WS_PROVIDER=${WS_URL}"
echo "NEXT_PUBLIC_CONTRACT_ADDRESS_SKILLCHAIN=${SKILLCHAIN_ADDR}"
echo "NEXT_PUBLIC_CONTRACT_ADDRESS_ESCROW=${ESCROW_ADDR}"

echo ""
info "Polkadot.js Apps:"
echo "https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/contracts"


