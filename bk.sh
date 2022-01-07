#!/bin/bash

############################  Installation of Terraform  ##########################

#First install terraform using below scripts 
choco install terraform
#Set environment variable in powershell
$env:Path += ":C:\ProgramData\chocolatey\lib\terraform\tools"
#Set environment variable in GitBash
export PATH=$PATH:"C:\ProgramData\chocolatey\lib\terraform\tools"

###################################################################################


#################################  Before Script  #################################

#Check version of Terraform
terraform -version

#######  Git Bash #############
#Export AWS Access Key ID in GitBash
export AWS_ACCESS_KEY_ID="Your_AWS_KEY_ID"
#Export AWS Secret Access Key in GitBash
export AWS_SECRET_ACCESS_KEY="Your_AWS_Secret_Key"
#Verify environment variables in GitBash
env | grep AWS

#######  PowerShell #############
#Export AWS Access Key ID in powershell
$env:AWS_ACCESS_KEY_ID = 'Your_AWS_KEY_ID'
#Export AWS Secret Access Key in powershell
$env:AWS_SECRET_ACCESS_KEY = 'Your_AWS_Secret_Key'
#Verify environment variables in powershell
dir env:

###################################################################################


####################################   Script  ####################################

#Initialize terraform
terraform init
#Validate changes
terraform validate
#Create a plan and save output to have a consistency between plan and execution
terraform plan -out bk.tfplan
#Apply script to create EKS cluster
terraform apply "bk.tfplan"

###################################################################################


################################### After Script  ##################################

#To destroy all configuration
terraform destroy

###################################################################################


