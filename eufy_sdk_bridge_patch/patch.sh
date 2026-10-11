#!/bin/sh
# Correctif eufy-sdk 0.4.0 : le cache des clés ECC (level-2 P2P) était indexé par cipher_id seul.
# Deux stations de comptes différents (caméra à soi + caméra partagée) peuvent avoir le même
# cipher_id avec des clés différentes : la 2e réutilisait la clé de la 1re → « level-2 key derivation failed ».
# Clé du cache = utilisateur admin + station + cipher_id.
set -e
f=$(grep -rl "cipherKeyCache.get(cipherId)" / --include=index.js 2>/dev/null | grep "@mega-yfue/eufy-sdk/dist" | head -1)
[ -n "$f" ] || { echo "eufy-sdk introuvable"; exit 1; }
sed -i 's/this\.cipherKeyCache\.has(cipherId)/this.cipherKeyCache.has(`${userId}|${stationSn}|${cipherId}`)/; s/this\.cipherKeyCache\.get(cipherId)/this.cipherKeyCache.get(`${userId}|${stationSn}|${cipherId}`)/; s/this\.cipherKeyCache\.set(cipherId, ecc)/this.cipherKeyCache.set(`${userId}|${stationSn}|${cipherId}`, ecc)/' "$f"
grep -c 'cipherKeyCache.\(has\|get\|set\)(`${userId}|${stationSn}|${cipherId}`' "$f"
