# ts-devops-demo

End-to-end DevOps project: a Spring Boot app built with Maven, packaged with Docker,
stored in Amazon ECR and deployed to EC2 by a Jenkins pipeline. Terraform creates the
AWS infrastructure.

## Flow

Developer -> GitHub -> Jenkins (Maven build -> Docker build -> push to ECR -> SSH deploy) -> App server (port 80)

## Tools

| Tool | Role |
| --- | --- |
| Git and GitHub | Source code, Dockerfile, Jenkinsfile, Terraform code |
| Terraform | Security groups, IAM roles, ECR repository, two EC2 instances |
| Maven | Compiles, tests and builds `target/ts-devops-demo.jar` |
| Docker | Builds the image and runs the container |
| Jenkins | Runs the pipeline in `Jenkinsfile` |
| AWS | EC2, ECR, IAM in `ap-south-1` |

## Repository layout

```text
ts-devops-demo/
|-- pom.xml
|-- Dockerfile
|-- Jenkinsfile
|-- src/                      Spring Boot application
`-- terraform/                AWS infrastructure
```

## Quick start

1. Create an EC2 key pair named `ts-devops-key` in `ap-south-1`.
2. Create the infrastructure:

   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars   # then edit key_name and my_ip
   terraform init
   terraform apply
   ```

3. Open the `jenkins_url` output, unlock Jenkins, install the suggested plugins and the
   **SSH Agent** plugin.
4. Add a credential with ID `app-server-ssh` (SSH Username with private key, username
   `ec2-user`, the contents of your `.pem` file).
5. Edit `Jenkinsfile`: replace `<account-id>` and `<app-private-ip>`, then commit and push.
6. Create a Pipeline job (Pipeline script from SCM, branch `*/main`, script path
   `Jenkinsfile`, Poll SCM `H/2 * * * *`) and click **Build Now**.
7. Open the `app_url` output in a browser.

## Run locally

```bash
mvn -B clean package
java -jar target/ts-devops-demo.jar
curl localhost:8080
```

## Cleanup

```bash
cd terraform
terraform destroy
```

Never commit access keys, `.pem` files or `terraform.tfvars`.
