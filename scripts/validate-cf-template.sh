#!/bin/bash
########################################
#
# Validates a cloudformation template
#
#########################################

echo ""
read -e -p "Enter Template filepath: " TEMPLATE
echo ""
echo "Validating the cloudfromation template"
echo "(a returned json list of template parameters is a success else an error will be returned)"
echo ""
aws cloudformation validate-template --template-body file:////$TEMPLATE
