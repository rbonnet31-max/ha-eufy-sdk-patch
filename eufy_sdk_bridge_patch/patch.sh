#!/bin/sh
# Correctif eufy-sdk 0.4.0 : le cache des clés ECC (level-2 P2P) était indexé par cipher_id seul.
# Deux stations de comptes différents (caméra à soi + caméra partagée) peuvent avoir le même
# cipher_id avec des clés différentes : la 2e réutilisait la clé de la 1re → « level-2 key derivation failed ».
# Clé du cache = utilisateur admin + station + cipher_id.
set -e
files=$(find / \( -path /proc -o -path /sys -o -path /dev \) -prune -o -type f \( -name '*.js' -o -name '*.mjs' -o -name '*.cjs' \) -print 2>/dev/null \
  | xargs grep -l "cipherKeyCache.get(cipherId)" 2>/dev/null || true)
[ -n "$files" ] || { echo "eufy-sdk introuvable"; exit 1; }
for f in $files; do
  echo "correctif : $f"
  sed -i 's/this\.cipherKeyCache\.has(cipherId)/this.cipherKeyCache.has(`${userId}|${stationSn}|${cipherId}`)/; s/this\.cipherKeyCache\.get(cipherId)/this.cipherKeyCache.get(`${userId}|${stationSn}|${cipherId}`)/; s/this\.cipherKeyCache\.set(cipherId, ecc)/this.cipherKeyCache.set(`${userId}|${stationSn}|${cipherId}`, ecc)/' "$f"
  grep -q 'cipherKeyCache.get(`${userId}|${stationSn}|${cipherId}`)' "$f" || { echo "échec sur $f"; exit 1; }
done
