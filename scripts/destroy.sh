#!/bin/bash
# Destroy script for AI Inference Server

echo "WARNING: This will destroy all resources created by Terraform."
echo "Resources to be destroyed: EC2 Instance, Security Group, Key Pair."
read -p "Are you sure? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cancelled."
    exit 1
fi

echo "Destroying resources..."
cd ../terraform
terraform destroy -auto-approve

echo "Cleanup complete."
