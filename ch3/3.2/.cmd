# Install docker ce and verify the installation
apt update && apt install docker-ce -y
docker --version

# Fork the following sample app repositories
## https://github.com/sungmincs/worklog-frontend_v1
## https://github.com/sungmincs/worklog-backend_v1
### When forking, uncheck `Copy the main branch only`

## Inside the control plane node
mkdir ~/workspace
cd ~/workspace
git clone https://github.com/<github_username>/worklog-frontend_v1.git
git clone https://github.com/<github_username>/worklog-backend_v1.git



# Run Sample App
## Run fullstack (frontend, backend, and database) locally
cd worklog-frontend_v1
docker compose up

# Access locally running sample App
## From the host, open a browser and Access
### frontend
http://192.168.1.10:8080
### backend
http://192.168.1.10:8000
