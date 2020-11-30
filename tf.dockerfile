FROM ubuntu:20.04

# Copy Terraform binary to /usr/local/bin
COPY --from=hashicorp/terraform:latest /bin/terraform /usr/local/bin/terraform
