# #!/bin/bash
# set -euxo pipefail

# echo "========== STARTING VM BOOTSTRAP =========="

# # VARIABLES (EDIT THESE)
# AZP_URL="https://dev.azure.com/cetera-org/zero-trust"     #"https://dev.azure.com/<YOUR-ORG>"
# #AZP_TOKEN="<YOUR-TOKEN>"
# AZP_POOL="self-hosted"
# AZP_AGENT_NAME="$(hostname)-$(date +%s)"



# # System Update
# apt-get update -y
# apt-get upgrade -y

# # Base Packages
# apt-get install -y \
#   curl wget git unzip jq \
#   apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# # Azure CLI
# curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# # kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# rm kubectl

# # Helm
# curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

# # Docker
# install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# chmod a+r /etc/apt/keyrings/docker.gpg

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
#   https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" \
#   > /etc/apt/sources.list.d/docker.list

# apt-get update -y
# apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# systemctl enable docker
# systemctl start docker
# usermod -aG docker azureuser
# newgrp docker 

# # Security Tools
# # Trivy
# wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
#   gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null

# echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" \
#   > /etc/apt/sources.list.d/trivy.list

# apt-get update -y
# apt-get install -y trivy

# # Gitleaks
# GITLEAKS_VERSION=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep -Po '"tag_name": "v\K[0-9.]+')
# wget -qO gitleaks.tar.gz https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
# tar -xzf gitleaks.tar.gz
# mv gitleaks /usr/local/bin/
# chmod +x /usr/local/bin/gitleaks
# rm -f gitleaks.tar.gz

# # Syft
# curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin


# # Prepare agent directory
# AGENT_DIR="/home/azureuser/agent"
# mkdir -p $AGENT_DIR
# cd $AGENT_DIR

# # Get latest agent version dynamically
# AGENT_VERSION=$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | jq -r '.tag_name' | sed 's/v//')

# # Download agent
# wget https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz

# tar zxvf vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz
# rm -f vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz

# chown -R azureuser:azureuser $AGENT_DIR

# # Login using Managed Identity
# #sudo -u azureuser az login --identity

# # Configure agent
# sudo -u azureuser ./config.sh --unattended \
#   --url $AZP_URL \
#   --auth pat \
#   --pool $AZP_POOL \
#   --agent $AZP_AGENT_NAME \
#   --acceptTeeEula \
#   --work _work \
#   --replace

# sudo ./svc.sh install
# sudo ./svc.sh start

# echo "========== VM BOOTSTRAP COMPLETE =========="

# echo "========== STARTING EPHEMERAL AGENT =========="

# # Run single job (ephemeral)
# sudo -u azureuser ./run.sh --once

# echo "===== JOB COMPLETE — SHUTTING DOWN ====="

# shutdown -h now













# #!/bin/bash

# apt update -y
# apt install -y curl jq git

# mkdir /actions-runner && cd /actions-runner

# curl -o actions-runner.tar.gz -L \
# https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz

# tar xzf actions-runner.tar.gz

# RUNNER_ALLOW_RUNASROOT=1 ./config.sh \
#   --url https://github.com/${github_org} \
#   --token $(curl -s ${token_url}) \
#   --name ${runner_name} \
#   --unattended

# ./run.sh




# #!/bin/bash
# # set -euxo pipefail
# set -e 

# echo "========== STARTING GITHUB SELF-HOSTED RUNNER BOOTSTRAP =========="


# # ==============================
# # SYSTEM BASE
# # ==============================
# apt-get update -y
# apt-get upgrade -y

# apt-get install -y \
#   curl wget git unzip jq \
#   apt-transport-https ca-certificates gnupg lsb-release \
#   software-properties-common

# # ==============================
# # AZURE CLI (for AKS + OIDC login later)
# # ==============================
# curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# # ==============================
# # KUBECTL
# # ==============================
# curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# install -m 0755 kubectl /usr/local/bin/kubectl
# rm kubectl

# # ==============================
# # HELM
# # ==============================
# curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

# # ==============================
# # DOCKER (for builds)
# # ==============================
# # Add Docker's official GPG key:
# sudo apt update
# sudo apt install ca-certificates curl
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc
# # Add the repository to Apt sources:
# sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
# Types: deb
# URIs: https://download.docker.com/linux/ubuntu
# Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
# Components: stable
# Architectures: $(dpkg --print-architecture)
# Signed-By: /etc/apt/keyrings/docker.asc
# EOF
# sudo apt update
# sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# sudo systemctl enable docker
# sudo systemctl start docker
# sudo usermod -aG docker $USER
# newgrp docker 

# # ==============================
# # SECURITY TOOLS (optional but enterprise-grade)
# # ==============================

# # Trivy (container scanning)
# wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
#   | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
# echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" \
# > /etc/apt/sources.list.d/trivy.list
# apt-get update -y
# apt-get install -y trivy

# # Gitleaks
# GITLEAKS_VERSION=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | jq -r '.tag_name' | sed 's/v//')
# wget -qO gitleaks.tar.gz \
# https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
# tar -xzf gitleaks.tar.gz
# install gitleaks /usr/local/bin/
# rm -f gitleaks.tar.gz

# # Syft (SBOM)
# curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh \
# | sh -s -- -b /usr/local/bin

# # Install Terraform 
# wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# sudo apt update && sudo apt install terraform -y

# # ==============================
# # VARIABLES (Injected via Terraform)
# # ==============================
# GITHUB_ORG="YOUR_ORG"
# RUNNER_NAME="$(hostname)-$(date +%s)"
# RUNNER_DIR="/home/azureuser/actions-runner"

# # MUST be injected securely via Terraform (NOT hardcoded)
# GITHUB_RUNNER_TOKEN="${github_runner_token}"




# # ==============================
# # RUNNER SETUP
# # ==============================
# mkdir -p ${RUNNER_DIR}
# cd ${RUNNER_DIR}

# chown -R azureuser:azureuser ${RUNNER_DIR}

# RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/v//')

# curl -O -L \
# https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# rm -f *.tar.gz

# # ==============================
# # CONFIGURE RUNNER (IMPORTANT FIXED PART)
# # ==============================
# sudo -u azureuser ./config.sh \
#   --unattended \
#   --url https://github.com/${GITHUB_ORG} \
#   --token ${GITHUB_RUNNER_TOKEN} \
#   --name ${RUNNER_NAME} \
#   --work _work \
#   --labels self-hosted,azure,aks,terraform \
#   --replace

# # ==============================
# # INSTALL AS SYSTEMD SERVICE (CRITICAL FIX)
# # ==============================
# ./svc.sh install azureuser
# ./svc.sh start






#!/bin/bash
set -e

echo "STARTING SIMPLE BOOTSTRAP"

# update
sudo apt-get update -y

# basic tools
sudo apt-get install -y curl git

# install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install Docker
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker azureuser
sudo chmod 666 /var/run/docker.sock
newgrp docker

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -m 0755 kubectl /usr/local/bin/kubectl

echo "BOOTSTRAP COMPLETE"