FROM ubuntu:20.04

# Get kubernetes goodness

# kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
&& chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# helm - https://helm.sh/docs/intro/install/
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
&& chmod +x get_helm.sh \
&& ./get_helm.sh
