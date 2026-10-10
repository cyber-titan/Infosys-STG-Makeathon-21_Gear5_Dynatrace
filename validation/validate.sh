#!/bin/bash
set -e

ERRORS=0

echo "=== Dynatrace Dashboard Factory — Validation ==="

# ── 1. Terraform format check ─────────────────────────────────────────────────
echo ""
echo "[1/4] Terraform format check..."
if ! terraform fmt -check -recursive ./dashboards ./alerts ./terraform; then
  echo "ERROR: Terraform formatting issues found. Run 'terraform fmt -recursive' to fix."
  ERRORS=$((ERRORS + 1))
else
  echo "OK: Formatting clean."
fi

# ── 2. Terraform syntax validation ────────────────────────────────────────────
echo ""
echo "[2/4] Terraform syntax validation..."
cd terraform
if ! terraform validate; then
  echo "ERROR: Terraform validation failed."
  ERRORS=$((ERRORS + 1))
else
  echo "OK: Syntax valid."
fi
cd ..

# ── 3. Secret scan ────────────────────────────────────────────────────────────
echo ""
echo "[3/4] Secret scan..."
# Scan for Dynatrace token patterns — dt0c01, dt0s01, dt0s16, etc.
SECRET_HITS=$(grep -rn --include="*.tf" --include="*.yml" --include="*.yaml" --include="*.json" \
  -E "dt0[a-zA-Z0-9]{2,4}\.[A-Z0-9]{8}\." . \
  --exclude-dir=".git" \
  --exclude-dir=".terraform" \
  2>/dev/null || true)

if [ -n "$SECRET_HITS" ]; then
  echo "ERROR: Possible Dynatrace token found in committed files:"
  echo "$SECRET_HITS"
  ERRORS=$((ERRORS + 1))
else
  echo "OK: No secrets detected."
fi

# ── 4. Structure check ────────────────────────────────────────────────────────
echo ""
echo "[4/4] Structure check — every dashboard/alert folder must have a .tf file..."

for dir in dashboards alerts; do
  if [ -d "$dir" ]; then
    find "$dir" -mindepth 2 -maxdepth 2 -type d | while read -r folder; do
      tf_count=$(find "$folder" -maxdepth 1 -name "*.tf" | wc -l)
      if [ "$tf_count" -eq 0 ]; then
        echo "ERROR: Folder '$folder' has no .tf file."
        ERRORS=$((ERRORS + 1))
      fi
    done
  fi
done
echo "OK: Structure valid."

# ── Result ────────────────────────────────────────────────────────────────────
echo ""
echo "================================================="
if [ "$ERRORS" -gt 0 ]; then
  echo "FAILED: $ERRORS check(s) failed. Fix before deploying."
  exit 1
else
  echo "PASSED: All checks passed. Ready for terraform apply."
  exit 0
fi
