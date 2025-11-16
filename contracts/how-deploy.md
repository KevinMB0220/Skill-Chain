# Despliegue local rápido (SkillChain y Escrow)

Objetivo: levantar nodo local, compilar y desplegar ambos contratos en minutos.

---

## 1) Prerrequisitos (una sola vez)
```bash
cargo install cargo-contract --force
cargo install contracts-node --git https://github.com/paritytech/substrate-contracts-node.git
```

## 2) Levantar nodo local
```bash
substrate-contracts-node --dev --tmp
```
Deja esta terminal abierta. Endpoint: `ws://127.0.0.1:9944`. Cuenta: `//Alice`.

---

## 3) SkillChain
```bash
cd contracts/skillchain
cargo contract build --release
export WS_LOCAL="ws://127.0.0.1:9944"
export SURI_LOCAL="//Alice"

# subir + instanciar
cargo contract upload --suri $SURI_LOCAL --url $WS_LOCAL --execute target/ink/skillchain.contract
cargo contract instantiate --suri $SURI_LOCAL --url $WS_LOCAL --constructor new --execute
```
Copia la address que imprime (ej.: `5ExpJz...`) y guárdala:
```bash
export SKILLCHAIN_ADDR="<pegar_address>"
```

---

## 4) Escrow
```bash
cd ../escrow
cargo contract build --release

cargo contract upload --suri //Alice --url ws://127.0.0.1:9944 --execute target/ink/escrow.contract
cargo contract instantiate --suri //Alice --url ws://127.0.0.1:9944 --constructor new --execute
```
Copia la address (ej.: `5HYv7f...`) y guárdala:
```bash
export ESCROW_ADDR="<pegar_address>"
```

---

## 5) Probar rápido (opcional)
```bash
# lectura SkillChain
cargo contract call \
  --contract $SKILLCHAIN_ADDR \
  --message get_profile \
  --args 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY \
  --suri //Alice --url $WS_LOCAL --dry-run

# escritura SkillChain
cargo contract call \
  --contract $SKILLCHAIN_ADDR \
  --message register_profile \
  --args "ipfs://QmDemoProfile" \
  --suri //Alice --url $WS_LOCAL --execute
```

UI: `https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/contracts` → “Add existing contract” con `target/ink/*.json` + address.

---

## 6) Frontend (.env.local)
```bash
NEXT_PUBLIC_WS_PROVIDER=ws://127.0.0.1:9944
NEXT_PUBLIC_CONTRACT_ADDRESS_SKILLCHAIN=<pegar $SKILLCHAIN_ADDR>
NEXT_PUBLIC_CONTRACT_ADDRESS_ESCROW=<pegar $ESCROW_ADDR>
```

Notas:
- Con `--tmp` el estado se borra al cerrar el nodo; la address cambia tras nuevo deploy (actualiza `.env.local`).
- Todo es local; no incluye testnets.

