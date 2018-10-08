# Background
This code base to deploy Jupyter Notebooks using JupyterHub is based on the open source reference implementation from https://github.com/jupyterhub/jupyterhub-deploy-docker.

It also uses Docker (https://www.docker.com/) containers to manage the three pieces of software needed to run this set up:
1. JupyterHub - takes care of authentication and notebook spawning
2. Jupyter Notebooks - notebook environment Python, R and Javascript kernels, plus BeakerX kernels (includes Scala and Java)
3. PostgreSQL - database backend to store notebook user data

# Installation Guide - Quick


## Prepare Jupyter Notebook server files
Git clone https://github.com/PHI-Toolkit/jupyterhub-deploy-docker-localhost. Change to the `jupyterhub-deploy-docker-localhost` folder and run the steps below.

## Round 1: Run `buildhub.sh` script unmodified
This enables you to run on `localhost` or an IP address (if you set it up on a remote VM, i.e., Digital Ocean, Lightsail or Linode), an unmodified Jupyter Notebook that has a self-signed certificate, and `jovyan` as the user.
1. Run `buildhub.sh`
2. When the script finishes, run the `starthub.sh` script
3. Go to https://localhost on your Chrome browser to view the JupyterHub log in page. The default login name and password are set in the `.env` file.

## Round 2: Run `buildhub.sh` script with LetsEncrypt certificate
Modify `.env` file LetsEncrypt section:
1. Get a domain name (e.g., example.com) from a domain registrar. Make the necessary changes so the DNS of the domain registrar points to the remote VM hosting the Jupyter Notebook server. Propagation of the domain name throughout the Internet may take a few hours.
2. Fill up `JH_FQDN`, `JH_EMAIL` and `CERT_SERVER` variables in the `.env` file.
3. Run the `stophub.sh` script if the Jupyter Notebook server is still running.
4. Run `buildhub.sh` script
5. Go to https://example.com/ (just an example of domain name) and authenticate as in Round 1.

## Round 3: Run `buildhub.sh` with GitHub Authentication
To enable GitHub autentication:
1. Edit the `.env` file and change the `JUPYTERHUB_AUTHENTICATOR` value to `github_authenticator`
2. Go to GitHub and obtain OAuth credentials (see below for details). Register if needed and obtain your GitHub user ID.
3. Plug in the values for `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`, and `OAUTH_CALLBACK_URL` in the corresponding variables in the `.env` file.
4. Edit the `userlist` file and add your GitHub user ID to the line below `jovyan` and add `admin` after your user ID. This enables you to use your GitHub user ID to authenticate via GitHub.
4. Run the `stophub.sh` script if the Jupyter Notebook server is still running.
5. Run the `buildhub.sh` script.
6. Run the `starthub.sh` script
7. Go to https://example.com. You will be redirected to the GitHub site to allow `hermantolentino` to autenticate you and to fill in your GitHub user ID and password. You will be redirected back to the Jupyter Notebook server after that.

# Installation Guide - Some Details for Remote Servers

## Prepare Jupyter Notebook server files
Git clone https://github.com/PHI-Toolkit/jupyterhub-deploy-docker-localhost. Change to the `jupyterhub-deploy-docker-localhost` folder and run the steps below.

## Install Docker and Docker Compose on your remote Virtual Machine (VM)

1. Run the `install-docker-bionic.sh` to install Docker and Docker Compose on a VM running Ubuntu Bionic.
2. If the VM is not running Bionic Beaver, run the `upgrade-distro.sh` script. Be sure to replace the source and destination OS in the `sed` statement.
3. Make sure to exit the VM and log back in for changes to take effect.

*References*
* Install Docker: https://docs.docker.com/install/
* Install Docker Compose: https://docs.docker.com/compose/install/

## JupyterHub Authentication

This build of JupyterHub has three options for Authentication. Go to about Line 18 of the `.env` file and set the environment variable `JUPYTERHUB_AUTHENTICATOR` to the selected option.
* tmp_authenticator
* dummy_authenticator (default)
* github_authenticator (thru OAuth, requires obtaining GitHub credentials, see below)

Possible scenarios for GitHub authentication (if you choose 'github_authenticator'):
1. Default GitHub settings in .env - no need to change or update any .env settings
2. Set up your own GitHub account and OAuth:

   2.1 Set up GitHub account

   2.2 Set up OAuth application (see below "Obtain GitHub Credentials")

## Obtain your GitHub Account Credentials
If you will be using GitHub Oauth to authenticate users to JupyterHub, you need to sign up for a GitHub Account:
1. Go to https://www.github.com and create an account if you do not have one yet.
2. Remember your GitHub user name. You will use this for #3 below.
3. Open the file `userlist` with your text editor and add your GitHub user name below "jovyan admin" as below:
> `<github user name> admin`

## Obtain GitHub OAuth Credentials
* Log in to GitHub
* Go to Developer Settings (https://github.com/settings/developers) - create new Oauth App
* Record the following information:
  * GitHub Client ID
  * GitHub Client Secret
  * GitHub Callback URL: This should be of the form https://"mydomain.com"/hub/oauth_callback if with a domain name (remember to replace "mydomain.com" with your domain name, as obtained from the step above, "Using a Domain Name".)
* Copy-paste each of these to right `.env` section (about Line 23):

> `GITHUB_CLIENT_ID=<github client id>`

> `GITHUB_CLIENT_SECRET=<github client secret>`

> `OAUTH_CALLBACK_URL=https://mydomain.com/hub/oauth_callback`

If using localhost, replace "mydomain.com" in OAUTH_CALLBACK with "localhost" (i.e., "https://localhost/hub/oauth_callback").

## Upgrading JupyterHub to a newer version

Upon runnng `starthub.sh`, you will likely see an error message saying you need to run `jupyterhub upgrade-db`. You can do this by:

1. Running the `upgrade-jupyterhub-db.sh` script against a running container

2. Commenting lines 71-72 of the `docker-compose.yml`, and uncommenting lines 73-74 (runs `jupyterhub upgrade-db`), then running `docker-compose build`. After running the database upgrade, run `stophub.sh` again, uncomment lines 71-72, comment out lines 73-74, and then running `docker-compose build` again. Then run `starthub.sh`. (based on https://jupyterhub.readthedocs.io/en/stable/reference/upgrading.html)

## Using custom Dockerfile or Docker Jupyter Stacks for your User Notebook Server

1. If using custom Dockerfile:<br/>
    a. DOCKER_NOTEBOOK_IMAGE=jupyter/minimal-notebook:e1677043235c<br/>
    b. DOCKERFILE=Dockerfile.custom
    
2. If using Docker Jupyter Stacks (https://github.com/jupyter/docker-stacks)<br/>
    a. DOCKER_NOTEBOOK_IMAGE can be any of the following:
      `jupyter/scipy-notebook:e1677043235c`, `jupyter/r-notebook:e1677043235c`, or `jupyter/datascience-notebook:e1677043235c`<br/>
    b. DOCKERFILE=Dockerfile.stacks

# Notes for Windows users

Windows 10 users should do the following:
1. To run the bash scripts in a bash shell on Windows 10, install the Linux Subsystem on Windows 10 here:
https://docs.microsoft.com/en-us/windows/wsl/install-win10
2. Use "Edge Channel" Docker version for Windows 10: https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe
3. Check "Expose daemon on tcp://localhost:2375 without TLS as follows:
![Windows 10 without TLS](./docs/25342.LINE.jpg)

# Upgrading from JupyterHub 0.7* to 0.8*
Delete the old `jupyterhub_cookie_secret` file:
> `$ sudo rm /var/lib/docker/volumes/jupyterhub-data/_data/jupyterhub_cookie_secret`

# Changes

## stacks-0.2

* **IMAGE_TAG variable**: See the `.env` file. Sets the Jupyter Stacks minimal image version to use in case of Dockerfile.custom or the stacks version in case of Dockerfile.stacks. For example, the Docker image for the singleuser-notebook that uses image tag `5811dcb711ba` is based on Ubuntu Bionic. The tags can be found here: https://hub.docker.com/r/jupyter/base-notebook/tags/.

* **GITHUB_ACCESS_TOKEN**: See `.env` file. Obtain your personal GitHub access token from https://github.com/settings/tokens.

## master

* based on docker stacks tag `459e68c2f8b7`.
* `jupyterHub=0.9.4`
* `notebook=5.7.0`

# JupyterHub Logs / Launch Issues

## Logs: Old base64 cookie-secret detected in /data/jupyterhub_cookie_secret.
* While jupyterhub is running, type the following commands:
> `$ docker exec -it jupyterhub /bin/bash`
* This brings you to the jupyterhub bash prompt. Type the following command to regenerate a new cookie secret:
> `# openssl rand -hex 32 > "/data/jupyterhub_cookie_secret"`
## Browser: 403 : Forbidden
* Add your GitHub username to the `userlist` file as described above.

## JupyterHub Logs: socket.gaierror: [Errno -2] Name or service not known
* If you see this error in the logs it means the JUPYTERHUB_SERVICE_HOST_IP is misconfigured.

## Windows user
* There may be slight differences in how Chrome or Firefox behaves compared to installations on Linux or Mac (YMMV).
