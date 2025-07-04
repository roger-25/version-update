#!/bin/bash
set -e

CLUSTER_NAME="version-update-poc"
REGION="us-east-1"

SUBNET_IDS=$(aws ec2 describe-subnets \
  --region $REGION \
  --filters Name=vpc-id,Values=$(aws eks describe-cluster --region $REGION --name $CLUSTER_NAME --query "cluster.resourcesVpcConfig.vpcId" --output text) \
  --query 'Subnets[].SubnetId' --output text)

for subnet_id in $SUBNET_IDS; do
  aws ec2 create-tags --region $REGION --resources $subnet_id \
    --tags Key=kubernetes.io/role/elb,Value=1 \
           Key=kubernetes.io/cluster/${CLUSTER_NAME},Value=owned
done
echo "Subnets tagged successfully for cluster ${CLUSTER_NAME} in region ${REGION}."