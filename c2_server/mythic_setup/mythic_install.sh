git clone https://github.com/its-a-feature/Mythic --depth 1 --single-branch
cd Mythic 
make
sudo -E ./mythic-cli install github https://github.com/MythicAgents/Apollo.git
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
