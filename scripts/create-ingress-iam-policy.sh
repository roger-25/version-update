#!/bin/bash
set -e

POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
POLICY_FILE="iam-policy.json"

# Download policy if not exists
if [ ! -f "$POLICY_FILE" ]; then
  curl -o "$POLICY_FILE" https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
fi

# Create IAM policy if not already created
if ! aws iam get-policy --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${POLICY_NAME} &>/dev/null; then
  aws iam create-policy \
    --policy-name ${POLICY_NAME} \
    --policy-document file://${POLICY_FILE}
else
  echo "Policy already exists. Skipping..."
fi
echo "IAM policy ${POLICY_NAME} created or already exists."