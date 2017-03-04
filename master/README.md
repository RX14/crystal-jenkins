To Setup master:

Security and basic setup is largely automated, the EC2 plugin and actual job set up are not automated.

1. Install docker and nginx using `apt-get`.
2. Clone this repository using `git`, and cd into the repository.
3. Use `docker build -t crystal-jenkins-master --build-arg password=<password> master` to build the docker image, with a default admin password of <password>.
4. Use `./start.sh` to start *or restart* the container. The data will be stored in the current directory, under `data`, so make sure to cd to where you want to store the data.
5. Jenkins is now running, but we need to configure nginx. First install acme.sh by running `curl https://get.acme.sh | sudo sh`. Then enter a root shell using `sudo -s`.
6. Bootstrap the initial certificate using acme.sh standalone mode: `acme.sh --issue --standalone -d jenkins.crystal-lang.org -d ci.crystal-lang.org`
7. Install the initial certificate using `acme.sh --install-cert -d jenkins.crystal-lang.org --keypath /etc/nginx/jenkins-key.pem --fullchainpath /etc/nginx/jenkins-fullchain.pem --reloadcmd "systemctl reload nginx"`. Exit from the root shell.
8. Copy the `nginx.conf` from this directory to `/etc/nginx/nginx.conf`. Use `sudo systemctl reload nginx` to load the new nginx configuration.
9. Use `acme.sh --issue --force -d jenkins.crystal-lang.org -d ci.crystal-lang.org -w /usr/share/nginx/html/acme/` in a new root shell (`sudo -s`) to make sure acme.sh uses nginx to renew in the future.
