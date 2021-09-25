# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# References:
# 1. https://github.com/jupyterhub/jupyterhub/blob/master/docs/source/reference/config-examples.md
# 2. https://github.com/jupyterhub/jupyterlab-hub
# Configuration file for JupyterHub
#
import os
import sys

c = get_config()

from jupyter_client.localinterfaces import public_ips

c.JupyterHub.logo_file = '/opt/miniconda/share/jupyterhub/static/images/jupyter.png'

#c.JupyterHub.spawner_class = DemoFormSpawner
# We rely on environment variables to configure JupyterHub so that we
# avoid having to rebuild the JupyterHub container every time we change a
# configuration parameter.

# Spawn single-user servers as Docker containers
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'

# Spawn containers from this image
c.DockerSpawner.image = os.environ['DOCKER_NOTEBOOK_IMAGE']
# JupyterHub requires a single-user instance of the Notebook server, so we
# default to using the `start-singleuser.sh` script included in the
# jupyter/docker-stacks *-notebook images as the Docker run command when
# spawning containers.  Optionally, you can override the Docker run command
# using the DOCKER_SPAWN_CMD environment variable.
if os.environ['JUPYTER_UI'] == '/lab':
    c.Spawner.cmd = ['jupyter-labhub']
    c.Spawner.default_url = '/lab'
else:
    spawn_cmd = os.environ.get('DOCKER_SPAWN_CMD', "start-singleuser.sh")
    c.DockerSpawner.extra_create_kwargs.update({ 'command': spawn_cmd })

# Spawner timeout
c.Spawner.http_timeout=60
c.Spawner.start_timeout=60
c.JupyterHub.tornado_settings = {'slow_spawn_timeout': 30}

# Connect containers to this Docker network
network_name = os.environ['DOCKER_NETWORK_NAME']
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = network_name
# Pass the network name as argument to spawned containers
c.DockerSpawner.extra_host_config = {
        'network_mode': network_name,
        'volume_driver': 'local'
    }
# Explicitly set notebook directory because we'll be mounting a host volume to
# it.  Most jupyter/docker-stacks *-notebook images run the Notebook server as
# user `jovyan`, and set the notebook directory to `/home/jovyan/work`.
# We follow the same convention.
notebook_dir = os.environ.get('DOCKER_NOTEBOOK_DIR') or '/home/jovyan/work'
c.DockerSpawner.notebook_dir = notebook_dir
# Mount the real user's Docker volume on the host to the notebook user's
# notebook directory in the container
#c.DockerSpawner.volumes = { 'jupyterhub-user-{username}': notebook_dir }
c.DockerSpawner.volumes = {
    'jupyterhub-user-{username}': notebook_dir,
    'jupyter-shared': '/home/jovyan/work/shared/',
    'jupyter-user-{username}-condaenv':'/opt/conda/'
}

#c.DockerSpawner.extra_create_kwargs.update({ 'volume_driver': 'local' })
# Remove containers once they are stopped
c.DockerSpawner.remove_containers = True
# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True

# User containers will access hub by container name on the Docker network
#c.JupyterHub.hub_ip = '0.0.0.0'
#c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = os.environ['JUPYTERHUB_SERVICE_HOST_IP']
c.JupyterHub.hub_port = 8080
#c.JupyterHub.generate_certs = True
#c.JupyterHub.internal_ssl = True

ipaddress = public_ips()[0]

c.JupyterHub.bind_url = 'http://0.0.0.0:8000'
c.JupyterHub.hub_bind_url = 'http://0.0.0.0:8081'
c.JupyterHub.hub_connect_url = f"http://{ipaddress}:8081"

# TLS config
# If using GitHub Authenticator, make sure to update .env file:
# 1. Update the GitHub credentials section
# 2. Update SSL option: use_ssl_le or use_ssl_ss
if os.environ['JUPYTERHUB_SSL'] =='no_ssl':
    c.JupyterHub.port = 8000
    c.JupyterHub.ssl_key = ''
    c.JupyterHub.ssl_cert = ''
    #c.JupyterHub.internal_certs_location = 'internal-ssl'
else:
    c.JupyterHub.port = 443
    c.JupyterHub.ssl_key = os.environ['SSL_KEY']
    c.JupyterHub.ssl_cert = os.environ['SSL_CERT']

# Authenticators: pick one from 1, 2 or 3 below and comment out the others
# DEFAULT is dummy_authenticator
if os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'dummy_authenticator':
# DEFAULT in .env
# 1. Dummy Authenticator  do not use this for production!
    c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
    c.DummyAuthenticator.password = os.environ['DUMMY_AUTH_PASSWORD']
elif os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'hash_authenticator':
# 2. Authenticate users with GitHub OAuth
    c.JupyterHub.authenticator_class = 'hashauthenticator.HashAuthenticator'
    c.HashAuthenticator.secret_key = 'geeks'          # Defaults to ''
    c.HashAuthenticator.password_length = 10          # Defaults to 6
    c.HashAuthenticator.show_logins = True            # Optional, defaults to Falseelif os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'github_authenticator':
elif os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'github_authenticator':
# 3. Authenticate users with GitHub OAuth
    c.JupyterHub.authenticator_class = 'oauthenticator.GitHubOAuthenticator'
    c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
    c.GitHubConfig.access_token = os.environ.get('GITHUB_ACCESS_TOKEN')
    c.GitHubConfig.client_id = os.environ.get('GITHUB_CLIENT_ID')
    c.GitHubConfig.client_secret = os.environ.get('GITHUB_CLIENT_SECRET')

elif os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'native_authenticator':
# 4. Authenticate users with Native Authenticator
    c.JupyterHub.authenticator_class = 'nativeauthenticator.NativeAuthenticator'
    if os.environ['NATIVEAUTH_SIGNUP'] == 'open_signup':
        c.NativeAuthenticator.open_signup = True
    else:
        c.NativeAuthenticator.open_signup = False
    c.NativeAuthenticator.minimum_password_length = 10
    c.NativeAuthenticator.check_common_password = True
    if os.environ['NATIVEAUTH_EMAIL'] == 'yes':
        c.Authenticator.ask_email_on_signup = True
    else:
        c.Authenticator.ask_email_on_signup = False
    c.Authenticator.allowed_failed_logins = 3
    c.Authenticator.seconds_before_next_try = 1200
else:
# 5. JupyterHub tmpauthenticator
# this creates temporary users
    c.JupyterHub.authenticator_class = tmpauthenticator.TmpAuthenticator

# Persist hub data on volume mounted inside container
data_dir = os.environ.get('DATA_VOLUME_CONTAINER', '/data')

c.JupyterHub.cookie_secret_file = os.path.join(data_dir,
    'jupyterhub_cookie_secret')

if os.environ.get('JUPYTERHUB_DB_URL') == 'postgres':
    c.JupyterHub.db_url = 'postgresql://postgres:{password}@{host}/{db}'.format(
        host=os.environ['POSTGRES_HOST'],
        password=os.environ['POSTGRES_PASSWORD'],
        db=os.environ['POSTGRES_DB'],)
else:
    c.JupyterHub.db_url = 'sqlite:///jupyterhub.sqlite' #default

# services
c.JupyterHub.template_paths = ['/srv/jupyterhub/templates']
c.JupyterHub.services = [
    {
        'name': 'cull-idle',
        'admin': True,
        'command': 'python cull_idle_servers.py --timeout={server_timeout_seconds}'.format(
            server_timeout_seconds=os.environ['SERVER_TIMEOUT_SECONDS']
            ).split(),

    },
    {
        'name': 'announcement',
        'url': 'http://127.0.0.1:8888',
        'command': ["python", "-m", "jupyterhub_announcement"],
    }
]
# Do not comment out this line below!
c.ConfigurableHTTPProxy.auth_token = open('/etc/proxy_token','r').read().replace('\n','')

if os.environ['ALLOW_NAMED_SERVERS'] == 'yes':
    c.JupyterHub.allow_named_servers = True
    c.JupyterHub.named_server_limit_per_user = 2

pwd = os.path.dirname(__file__)
whitelist = set()
admin = set()
with open(os.path.join(pwd, 'userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name = parts[0]
        whitelist.add(name)
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)

# Whitlelist users and admins
c.Authenticator.allowed_users = whitelist
c.Authenticator.admin_users = admin
c.JupyterHub.admin_access = True
c.JupyterHub.upgrade_db = True
