#!/bin/bash
set -e

set -a
source .env
set +a

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --instance-id) INSTANCE_ID="$2"; shift ;;
    --region) REGION="$2"; shift ;;
    --script-path) SCRIPT_PATH="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

if [[ -z "$INSTANCE_ID" || -z "$REGION" || -z "$SCRIPT_PATH" ]]; then
  echo "Missing required arguments: --instance-id, --region, --script-path"
  exit 1
fi

# Use jq to read the script content and escape it for SSM
SCRIPT_CONTENT=$(jq -Rs '.' < "$SCRIPT_PATH")

echo "Sending SSM command to instance $INSTANCE_ID..."

COMMAND_ID=$(aws ssm send-command \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --comment "Deployment via GitHub Actions" \
  --parameters "{\"commands\": [$SCRIPT_CONTENT]}" \
  --query "Command.CommandId" \
  --output text)

echo "Command ID: $COMMAND_ID"

for i in {1..30}; do
  STATUS=$(aws ssm list-command-invocations \
    --command-id "$COMMAND_ID" \
    --region "$REGION" \
    --query "CommandInvocations[0].Status" \
    --output text)

  echo "Current status: $STATUS"

  if [[ "$STATUS" == "Success" ]]; then
    echo "SSM command executed successfully."
    exit 0
  elif [[ "$STATUS" == "Failed" || "$STATUS" == "Cancelled" || "$STATUS" == "TimedOut" ]]; then
    echo "SSM command failed with status: $STATUS"
    exit 1
  fi

  sleep 10
done

echo "SSM command did not finish within the expected time."
exit 1
