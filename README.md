# Background
This code base to deploy Jupyter Notebooks using JupyterHub is based on the reference implementation from https://github.com/jupyterhub/jupyterhub-deploy-docker.

# Installation Guide

## Install Docker and Docker Compose

## Create secrets directory
Type the following on your Linux command line:
> `mkdir secrets`
> `pwd`
You will copy the result of `pwd` later to your `letsencrypt-certs.sh` file,

## Obtain Domain name
If you intend to use JupyterHub on your laptop for localhost use, there is no need to obtain a domain name and you can skip this step. If JuypterHub will be used with a domain name, obtain domain name. Open the `letsencrypt-certs.sh` bash script with a text editor (e.g., nano) and edit the first few lines (lines 3, 4 and 5):

* For the line below, replace "mydomain.com" with your domain name, "e.g., example.com"
> `export JH_FQDN="mydomain.com"`
* For the line below, replace email address with your email address
> `export JH_EMAIL="myname@mydomain.com"`
* For the line below, replace "/path/to" with full path (result of pwd)
> `export JH_SECRETS="/path/to/secrets"`

## Create SSL Certificate (two options)
### Self-signed certificate (localhost or with domain name)
> `$`
> `$ chmod a+x create-certs.sh`
> `$ ./create-certs.sh`

### Obtain "Lets Encrypt" SSL Certificate
> `$`
> `$ chmod a+x letsencrypt-certs.sh`
> `$ ./letsencrypt-certs.sh`

## Obtain your GitHub Account
You will be using GitHub Oauth to authenticate users to JupyterHub. Open the file `userlist` with your text editor and add your GitHub user name below "jovyan admin" as below:
> `<github username> admin`

## Obtain GitHub OAuth Credentials
* Log in to GitHub
* Go to Developer Settings - create new Oauth App
* Record the following information:
  * GitHub Client ID
  * GitHub Client Secret
  * GitHub Callback URL: This should be of the form https://mydomain.com/hub/oauth_callback if with a domain name (remember to replace "mydomain.com" with your domain name, as obtained from the step above.)
* Copy these to right `.env` section:
> `# obtain GitHub OAuth credentials from https://github.com/settings/developers`
> `GITHUB_CLIENT_ID=<github client id>`
> `GITHUB_CLIENT_SECRET=<github client secret>`
> `OAUTH_CALLBACK_URL=https://mydomain.com/hub/oauth_callback`

  If using localhost, replace "mydomain.com" in OAUTH_CALLBACK with "localhost:

## Generate Postgres password
This JupyterHub deployment uses the PostgreSQL database as a backend (instead of sqlite).
* Create the postgres password by typing the Linux command below:
> `$ openssl rand -hex 32`
* Copy the result of the command to the right `.env` section by replacing the `geeks@localhost` entry with the hex value:
> `POSTGRES_PASSWORD=geeks@localhost`
> `JPY_PSQL_PASSWORD=geeks@localhost`

## Create Docker networks and volumes
Type the following Linux commands on the command line:
> `$ make networks`
> `$ make volumes`

## Build the Notebook Server Docker Image
Type the following command on the command line:
> `$ make notebook_image`

## Build the PostgreSQL 9.5 and JupyterHub Docker images
Type the following command on the command line:
> `$ docker-compose build`

## Launch JupyterHub and Browse Your Brand New Notebook Server
* If localhost, go to https://localhost in your browser. If using a domain name, go to https://mydomain.com.
* Sign in to GitHub using your account
