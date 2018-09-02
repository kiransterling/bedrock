#!/usr/bin/env bash
cd $(dirname $0)
docker build -t bedrock/base:do base/do
docker build -t bedrock/terraform:aws terraform_state/aws
docker build -t bedrock/terraform:local terraform_state/local
docker build -t bedrock/bastion:do -f base/do/Dockerfile.do bastion/do
docker build -t bedrock/bastion:aws -f base/do/Dockerfile.do bastion/aws
docker build -t bedrock/user:aws -f base/do/Dockerfile.do user/aws
docker build -t bedrock/reverseproxy:do -f base/do/Dockerfile.do reverseproxy/do

docker build -t bedrock/accelerator .