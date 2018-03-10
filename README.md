Terraform module which creates an EC2 instance inide a VPC with a security group that will allow for SSH access from all IPs, web access on port 80, a gatway, and some route mappings to let the whole thing talk to the internet.

The path to the AWS credentials file is hardcoded and is assumes you have a keypair called `sobotka`. TODO: change dis


Usage:

```shell
terraform apply
ssh -i ~/.ssh/sobotka.pem ubuntu@$(terraform state show aws_instance.web01 | grep "^public_ip" | awk '{print $3}'
```

