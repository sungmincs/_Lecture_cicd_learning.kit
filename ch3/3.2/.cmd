# Install docker ce and verify the installation
apt update && apt install docker-ce -y
docker --version

# Fork the following sample app repositories
## https://github.com/sungmincs/worklog-frontend-mock
## https://github.com/sungmincs/worklog-backend
### When forking, uncheck `Copy the main branch only`

## Inside the control plane node
mkdir ~/workspace
cd ~/workspace
git clone https://github.com/<github_username>/worklog-frontend-mock.git
git clone https://github.com/<github_username>/worklog-backend.git

# Run Sample App
## Run fullstack (frontend, backend, and database) locally
cd worklog-frontend-mock
docker compose up

# Access locally running sample App
## From the host, open a browser and Access
### frontend
http://192.168.1.10:8080
### backend
http://192.168.1.10:8000
