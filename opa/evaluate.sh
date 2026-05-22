#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
POLICY_DIR="$SCRIPT_DIR/policies"
PLAN_FILE="${1:-tfplan.json}"

if [ ! -f "$PLAN_FILE" ]; then
  echo "Error: Terraform plan JSON file not found: $PLAN_FILE"
  echo "Usage: $0 [path-to-tfplan.json]"
  echo ""
  echo "To generate the plan:"
  echo "  terraform plan -out=tfplan.binary"
  echo "  terraform show -json tfplan.binary > tfplan.json"
  exit 1
fi

echo "========================================="
echo "  OPA Policy Evaluation"
echo "========================================="
echo "Policies: $POLICY_DIR"
echo "Plan:     $PLAN_FILE"
echo ""

VIOLATIONS=$(opa eval \
  --format raw \
  --data "$POLICY_DIR" \
  --input "$PLAN_FILE" \
  "data.terraform.deny" 2>&1) || true

if [ "$VIOLATIONS" == "[]" ] || [ -z "$VIOLATIONS" ]; then
  echo "All OPA policies passed!"
  exit 0
else
  echo "OPA Policy Violations Found:"
  echo "----------------------------------------"
  if echo "$VIOLATIONS" | jq empty 2>/dev/null; then
    echo "$VIOLATIONS" | jq -r '.[]'
  else
    echo "$VIOLATIONS"
  fi
  echo "----------------------------------------"
  echo ""
  if echo "$VIOLATIONS" | jq empty 2>/dev/null; then
    COUNT=$(echo "$VIOLATIONS" | jq 'length')
    echo "Total violations: $COUNT"
  fi
  exit 1
fi
