FROM ubuntu:20.04

# amd64 or aarch64
ARG arch="amd64"
# x86_64 or aarch64
ARG alt_arch_name="x86_64"
# specify Terraform release
ARG tf_version="0.12.29"

RUN apt-get update \
  && apt-get install -y \
    curl \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
    unzip \
    # kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${arch}/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    # helm - https://helm.sh/docs/intro/install/
    && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh \
    # install Azure CLI - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=${arch}] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install -y azure-cli \
    # install AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-${alt_arch_name}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip \
    # install eksctl - https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html#install-eksctl-linux
    && curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${arch}.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin \
    # install Terraform - https://www.terraform.io/downloads.html
    && curl -o "/tmp/terraform.zip" "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_${arch}.zip" \
    && unzip /tmp/terraform.zip -d /tmp/terraform \
    && mv /tmp/terraform/terraform /usr/local/bin/terraform \
    # clean up
    && apt-get autoclean \
    && rm -rf \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*
