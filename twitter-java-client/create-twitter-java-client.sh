#!/bin/bash
########################################
#
# script to create the hashtag gibraltar
# stack
#
#
#########################################

clear
IP_ADDRESS=$(wget -qO- http://checkip.amazonaws.com/)
echo " "
echo "Enter the IAM role"
read -r IAM_ROLE
echo " "
echo "Enter the ssh key pair name"
read -r KEY_PAIR
echo " "
read -e -p "Enter Template filepath: " TEMPLATE
echo ""

SSH_CIDR="$IP_ADDRESS/32"

STACK_NAME="twitter-java-client-stack"
NEW_STACK_STATUS=" "

aws cloudformation create-stack --stack-name $STACK_NAME --template-body file:////$TEMPLATE --parameters ParameterKey=KeyPairName,ParameterValue=$KEY_PAIR ParameterKey=IamProfileName,ParameterValue=$IAM_ROLE ParameterKey=SSHLocation,ParameterValue=$SSH_CIDR

echo ""
echo "Creating stack for hashtag gibraltar (security group ingress ip: $SSH_CIDR)"
echo " "

for i in {1..100}
do
	NEW_STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[*].[StackStatus]' --output text)
	echo "Stack Status: $NEW_STACK_STATUS"
	if [ $NEW_STACK_STATUS == "CREATE_COMPLETE" ]
		then echo " " 
		aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[*].[Outputs]' --output text 
		echo " "
		break
	elif [ $NEW_STACK_STATUS == "ROLLBACK_COMPLETE" ]
		then echo " "
		break
	else
	    echo $NEW_STACK_STATUS
	fi
	sleep 10
done

echo " "
echo "access server with ssh (ssh -i {key_pair} -p 22 ec2-user@{instance_public_dns})"
echo " "
