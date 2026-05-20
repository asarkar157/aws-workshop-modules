#!/bin/bash
# ============================================================
# StackGen Workshop — AWS Credential Setup
# ============================================================
# This script creates:
#   1. AWS IAM Policy for the workshop (StackGenWorkshopPolicy)
#   2. AWS IAM User (stackgen-workshop-user)
#   3. Attaches the policy to the user
#   4. Generates an Access Key and Secret Key
#
# Prerequisites:
#   - AWS CLI installed and configured with Admin credentials
#   - jq installed (optional)
#
# Usage:
#   chmod +x setup_credentials.sh
#   ./setup_credentials.sh
# ============================================================

set -euo pipefail

USER_NAME="stackgen-workshop-user"
POLICY_NAME="StackGenWorkshopPolicy"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "==> Creating custom IAM policy..."
cat > /tmp/workshop-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "s3:*",
                "rds:*",
                "dynamodb:*",
                "secretsmanager:*",
                "ecr:*",
                "apprunner:*",
                "iam:PassRole",
                "iam:CreateRole",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:GetRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies"
            ],
            "Resource": "*"
        }
    ]
}
EOF

# Check if policy exists, create if not
POLICY_ARN="arn:aws:iam::${ACCOUNT_ID}:policy/${POLICY_NAME}"
if aws iam get-policy --policy-arn "${POLICY_ARN}" >/dev/null 2>&1; then
    echo "    Policy ${POLICY_NAME} already exists. Skipping creation."
else
    aws iam create-policy --policy-name "${POLICY_NAME}" --policy-document file:///tmp/workshop-policy.json >/dev/null
    echo "    Policy ${POLICY_NAME} created."
fi

echo "==> Creating IAM User..."
if aws iam get-user --user-name "${USER_NAME}" >/dev/null 2>&1; then
    echo "    User ${USER_NAME} already exists."
else
    aws iam create-user --user-name "${USER_NAME}" >/dev/null
    echo "    User ${USER_NAME} created."
fi

echo "==> Attaching policy to user..."
aws iam attach-user-policy --user-name "${USER_NAME}" --policy-arn "${POLICY_ARN}" >/dev/null
echo "    Policy attached."

echo "==> Cleaning up old access keys..."
# List all existing access keys for the user and delete them to prevent hitting the 2-key limit
EXISTING_KEYS=$(aws iam list-access-keys --user-name "${USER_NAME}" --query 'AccessKeyMetadata[*].AccessKeyId' --output text)
for KEY in $EXISTING_KEYS; do
    echo "    Deleting old key: $KEY"
    aws iam delete-access-key --user-name "${USER_NAME}" --access-key-id "$KEY"
done

echo "==> Generating New Access Key..."
# Now guaranteed to succeed since all old keys are deleted
CREDS_JSON=$(aws iam create-access-key --user-name "${USER_NAME}" --output json)
ACCESS_KEY=$(echo "$CREDS_JSON" | grep -o '"AccessKeyId": "[^"]*' | cut -d'"' -f4)
SECRET_KEY=$(echo "$CREDS_JSON" | grep -o '"SecretAccessKey": "[^"]*' | cut -d'"' -f4)

echo ""
echo "============================================================"
echo "  WORKSHOP CREDENTIALS — Share with customer"
echo "============================================================"
echo ""
echo "  # Configure AWS CLI (via env vars):"
echo "  export AWS_ACCESS_KEY_ID=\"$ACCESS_KEY\""
echo "  export AWS_SECRET_ACCESS_KEY=\"$SECRET_KEY\""
echo "  export AWS_DEFAULT_REGION=\"us-east-1\""
echo ""
echo "============================================================"
echo "  ⚠️  Store these credentials securely. Revoke after workshop:"
echo "  aws iam delete-access-key --user-name ${USER_NAME} --access-key-id ${ACCESS_KEY}"
echo "============================================================"
