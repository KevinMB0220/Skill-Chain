# SkillChain Contract Deployment Guide

## ✅ Contrato compilado exitosamente

**Artifacts generados:**
- `skillchain.contract` (35KB) - Bundle completo (código + metadata)
- `skillchain.wasm` (13KB) - Código WASM optimizado  
- `skillchain.json` (26KB) - Metadata/ABI del contrato

**Ubicación:** `/Users/josue/OSS/SkillChain/contracts/skillchain/target/ink/`

---

## 🚀 Opciones de Deployment

### 1. Local Development (Recomendado para empezar)

#### Opción A: substrate-contracts-node

```bash
# Instalar el nodo
cargo install contracts-node --git https://github.com/paritytech/substrate-contracts-node.git

# Ejecutar nodo local
substrate-contracts-node --dev --tmp

# El nodo estará en: ws://127.0.0.1:9944
```

#### Opción B: Pop CLI (Simplificado)

```bash
# Instalar Pop CLI
cargo install --git https://github.com/r0gue-io/pop-cli

# Iniciar nodo local
pop up contract
```

### 2. Testnet Pública

#### Paseo Testnet (Recomendado para hackathons)

- **RPC:** `wss://paseo-rpc.dwellir.com` o `wss://paseo.rpc.amforc.com`
- **Explorer:** https://paseo.subscan.io/
- **Faucet:** Solicitar tokens en Discord de Polkadot

#### Rococo Contracts (Alternativa)

- **RPC:** Verificar en https://wiki.polkadot.network/docs/rococo-contracts
- **Explorer:** https://rococo.subscan.io/

---

## 📤 Métodos de Deployment

### A. Via Polkadot.js Apps UI (Más fácil)

1. **Abrir Polkadot.js Apps:**
   - Local: https://polkadot.js.org/apps/?rpc=ws://127.0.0.1:9944#/contracts
   - Paseo: https://polkadot.js.org/apps/?rpc=wss://paseo-rpc.dwellir.com#/contracts

2. **Upload Contract:**
   - Click en "Upload & deploy code"
   - Seleccionar `skillchain.contract`
   - Click "Next"

3. **Deploy:**
   - Constructor: `new()`
   - Sin parámetros
   - Click "Deploy"
   - Firmar con tu wallet

4. **Copiar dirección del contrato** para integración

### B. Via cargo-contract CLI

```bash
cd /Users/josue/OSS/SkillChain/contracts/skillchain

# Para nodo local
cargo contract upload \
  --suri //Alice \
  --url ws://127.0.0.1:9944 \
  --execute

cargo contract instantiate \
  --suri //Alice \
  --constructor new \
  --url ws://127.0.0.1:9944 \
  --execute

# Para testnet (requiere tu seed phrase)
cargo contract upload \
  --suri "your twelve word seed phrase here" \
  --url wss://paseo-rpc.dwellir.com \
  --execute

cargo contract instantiate \
  --suri "your twelve word seed phrase here" \
  --constructor new \
  --url wss://paseo-rpc.dwellir.com \
  --execute
```

### C. Via Script (Automatizado)

Crear `deploy.sh`:

```bash
#!/bin/bash

# Configuration
NETWORK=${1:-local}  # local, paseo, rococo
SURI=${2:-//Alice}   # Default to Alice for local

case $NETWORK in
  local)
    URL="ws://127.0.0.1:9944"
    ;;
  paseo)
    URL="wss://paseo-rpc.dwellir.com"
    ;;
  rococo)
    URL="wss://rococo-contracts-rpc.polkadot.io"
    ;;
  *)
    echo "Unknown network: $NETWORK"
    exit 1
    ;;
esac

echo "🚀 Deploying to $NETWORK..."
echo "URL: $URL"

# Upload code
echo "📤 Uploading contract code..."
cargo contract upload \
  --suri "$SURI" \
  --url "$URL" \
  --execute

# Instantiate
echo "🎬 Instantiating contract..."
cargo contract instantiate \
  --suri "$SURI" \
  --constructor new \
  --url "$URL" \
  --execute

echo "✅ Deployment complete!"
```

Uso:
```bash
chmod +x deploy.sh
./deploy.sh local              # Deploy local con Alice
./deploy.sh paseo "your seed"  # Deploy a Paseo
```

---

## 🧪 Testing del Contrato Desplegado

### Via Polkadot.js Apps

1. Ir a "Developer" → "Contracts"
2. Click en tu contrato desplegado
3. Probar funciones:
   - `register_profile("ipfs://QmExample")`
   - `add_claim(receiver, "hackathon_win", 0x...)`
   - `approve_claim(0)`
   - `get_profile(account)`
   - `get_claims(account)`

### Via cargo-contract CLI

```bash
# Llamar función
cargo contract call \
  --contract <CONTRACT_ADDRESS> \
  --message register_profile \
  --args "ipfs://QmMyProfile" \
  --suri //Alice \
  --execute

# Query (read-only)
cargo contract call \
  --contract <CONTRACT_ADDRESS> \
  --message get_profile \
  --args <ACCOUNT_ID> \
  --suri //Alice \
  --dry-run
```

---

## 🔗 Integración con Frontend

Una vez desplegado, configura el frontend:

```bash
# app/web/.env.local
NEXT_PUBLIC_WS_PROVIDER=ws://127.0.0.1:9944
NEXT_PUBLIC_CONTRACT_ADDRESS=<tu_contract_address>
```

El SDK TypeScript (`sdk/js/`) usará estos valores para conectar.

---

## 📊 Monitoreo

### Local
- **Logs:** Ver la terminal donde corre el nodo
- **Telemetry:** https://telemetry.polkadot.io/

### Testnet
- **Paseo Explorer:** https://paseo.subscan.io/
- **Buscar tu contrato** por address
- **Ver transacciones** y eventos

---

## 🐛 Troubleshooting

### Error: "InsufficientBalance"
- Necesitas tokens de prueba
- Local: Alice tiene fondos por defecto
- Testnet: Solicitar en faucet

### Error: "ContractTrapped"
- Revisar los parámetros de la función
- Verificar que el contrato esté inicializado

### Error: "ContractNotFound"
- Verificar la dirección del contrato
- Asegurarse de estar en la red correcta

---

## 📝 Próximos Pasos

1. ✅ Contrato compilado
2. 🚀 **Siguiente:** Desplegar en local o testnet
3. 🔧 Implementar SDK TypeScript
4. 💻 Conectar frontend Next.js
5. 🎨 UI/UX para demo

---

## 🎯 Para el Hackathon

**Recomendación:**
1. Deploy local para desarrollo rápido
2. Deploy a **Paseo testnet** para la demo final
3. Preparar wallet con fondos de testnet
4. Grabar video de interacción con el contrato
5. Documentar el contract address en el README

¡El contrato está listo para deployment! 🚀

