sudo apt update && sudo apt full-upgrade -y
sudo apt-get install build-essential

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl status docker 
sudo systemctl start docker 

# Testing sucessful installation
sudo docker run hello-world

# Post installation to run without sudo 
sudo groupadd docker 
sudo usermod -aG docker $USER 
newgrp docker

# Verification to run without sudo 
docker run hello-world

# Clone Mythic Repo 
cd 
git clone https://github.com/its-a-feature/Mythic --depth 1 --single-branch

# Make the mythic-cli binary as it is no longer shipped 
cd Mythic 
sudo make 

# Install Apollo Mythic Agent
sudo -E ./mythic-cli install github https://github.com/MythicAgents/Apollo.git

sudo -E ./mythic-cli install github https://github.com/MythicC2Profiles/http

# Verify installed C2Profile and MythicAgent 
ll InstalledServices

echo "You now run: sudo ./mythic-cli start"













