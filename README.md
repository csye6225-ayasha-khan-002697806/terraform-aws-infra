# terraform-aws-infra

tf-aws-infra : CI with git action
run the terraform fmt recursively and terraform validate. A pull request can only be merged if the workflow executes successfully...

## terraform-aws-infra:
We are deploying the AWS infrastructure using the Terraform code.

1) We have the file **.tfvars** for providing the  environment variables for demo or dev environemnt.

Use the below commands to run the project with the environment variable values.

### Initialize
```bash
terraform init
```

### Format
```bash
terraform fmt
```

### validate
```bash
terraform validate
```

### Use demo cli
```bash
export AWS_PROFILE=profile_name
```

### Plan the deployment
```bash
terraform plan -var-file=tfvars/terraform.tfvars
```

### Destroy
```bash
terraform destroy -var-file=tfvars/terraform.tfvars
```

Use the below commands to run the project without the environment variable values and generate with random values.
### Initialize
```bash
terraform init
```

### Plan the deployment
```bash
terraform plan
```

### Apply
```bash
terraform apply
```

### Destroy
```bash
terraform destroy
```
 

 ### for Assignment 05


To connect with postgres database on RDS instance from EC2

1. install postgres client
   1. sudo apt-get update
   2. sudo apt-get install postgresql-client -y
2. connect to DB
   1. psql -h RDS_endpoint -U db_username -d database_name -W
