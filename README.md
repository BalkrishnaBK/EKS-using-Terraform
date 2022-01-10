# Creation of EKS cluster using Terraform
## Table Of Content
[Introduction](#Introduction)

[Installation of Terraform](#Installation-of-Terraform)

[Before Script](#Before-Script)

[Main Terraform Script](#Main-Terraform-Script)

[After Script](#After-Script)

### Intorduction
Creation of EKS cluster by using Terraform basic script. Currently, this is very basic script which will just spawn your EKS cluster. 
Below are two modules which needed for EKS cluster
- VPC Module 
- EKS Module

### Installation of Terraform
Terraform installation script
```
choco install terraform
```

Set environment variable in powershell
```
$env:Path += ":C:\ProgramData\chocolatey\lib\terraform\tools"
```

```

```
Set environment variable in GitBash
```
export PATH=$PATH:"C:\ProgramData\chocolatey\lib\terraform\tools"
```
### Before Script
Check version of Terraform
```
terraform -version
```
Below are the two options to run commands

##### Using Git-Bash
Export AWS Access Key ID in GitBash
```
export AWS_ACCESS_KEY_ID="Your_AWS_KEY_ID"
```
Export AWS Secret Access Key in GitBash
```
export AWS_SECRET_ACCESS_KEY="Your_AWS_Secret_Key"
```
Verify environment variables in GitBash
```
env | grep AWS
```



##### Using Powershell
Export AWS Access Key ID in GitBash
```
$env:AWS_ACCESS_KEY_ID = 'Your_AWS_KEY_ID'
```
Export AWS Secret Access Key in GitBash
```
$env:AWS_SECRET_ACCESS_KEY = 'Your_AWS_Secret_Key'
```
Verify environment variables in GitBash
```
dir env:
```
### Main Terraform Script
Initialize terraform
```
terraform init
```

Validate changes
```
terraform validate
```

Create a plan and save output to have a consistency between plan and execution
```
terraform plan -out bk.tfplan
```

Apply script to create EKS cluster
```
terraform apply "bk.tfplan"
```

### After Script
To destroy all configuration
```
terraform destroy
```



## License

[MIT License](https://github.com/BalkrishnaBK/EKS-using-Terraform/blob/main/LICENSE)

**Free Software, Hell Yeah!**

Copyright (c) 2021 Balkrishna Mangal Atmaram Londhe
