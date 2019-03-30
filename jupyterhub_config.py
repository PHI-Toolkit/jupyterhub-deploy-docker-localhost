# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# References:
# 1. https://github.com/jupyterhub/jupyterhub/blob/master/docs/source/reference/config-examples.md
# 2. https://github.com/jupyterhub/jupyterlab-hub
# Configuration file for JupyterHub
#
import os
import tmpauthenticator

c = get_config()

from dockerspawner import DockerSpawner

class DemoFormSpawner(DockerSpawner):
    def _options_form_default(self):
        default_stack = "jupyter/minimal-notebook"
        return """
        <label for="stack">Select your desired stack</label>
        <select name="stack" size="1">
        <option value="jupyter/r-notebook">R: </option>
        <option value="jupyter/tensorflow-notebook">Tensorflow: </option>
        <option value="jupyter/datascience-notebook">Datascience: </option>
        <option value="jupyter/all-spark-notebook">Spark: </option>
        </select>
        """.format(stack=default_stack)

    def options_from_form(self, formdata):
        options = {}
        options['stack'] = formdata['stack']
        container_image = ''.join(formdata['stack'])
        print("SPAWN: " + container_image + " IMAGE" )
        self.container_image = container_image
        return options

c.JupyterHub.logo_file = '/opt/conda/share/jupyter/hub/static/images/jupyter.png'

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
if os.environ['JUPYTER_UI'] == 'notebook':
    spawn_cmd = os.environ.get('DOCKER_SPAWN_CMD', "start-singleuser.sh")
    c.DockerSpawner.extra_create_kwargs.update({ 'command': spawn_cmd })
else:
    c.Spawner.default_url = '/lab'
    c.Spawner.cmd = ['jupyter-labhub']

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
    'jupyter-shared': '/home/jovyan/work/shared/'
}

#c.DockerSpawner.extra_create_kwargs.update({ 'volume_driver': 'local' })
# Remove containers once they are stopped
c.DockerSpawner.remove_containers = True
# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True

# User containers will access hub by container name on the Docker network
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = os.environ['JUPYTERHUB_SERVICE_HOST_IP']
#c.JupyterHub.hub_connect_ip = '172.19.0.3'
c.JupyterHub.hub_port = 8080

# TLS config
# If using GitHub Authenticator, make sure to update .env file:
# 1. Update the GitHub credentials section
# 2. Update SSL option: use_ssl_le or use_ssl_ss
c.JupyterHub.port = 443
c.JupyterHub.ssl_key = os.environ['SSL_KEY']
c.JupyterHub.ssl_cert = os.environ['SSL_CERT']

# Authenticators: pick one from 1, 2 or 3 below and comment out the others
# DEFAULT is dummy_authenticator
if os.environ['JUPYTERHUB_AUTHENTICATOR'] == 'dummy_authenticator':
# DEFAULT in .env
# 1. Dummy Authenticator  do not use this for production!
    c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
    c.DummyAuthenticator.password = "geeks@localhost"
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
else:
# 4. JupyterHub tmpauthenticator
# this creates temporary users
    c.JupyterHub.authenticator_class = tmpauthenticator.TmpAuthenticator

c.GitHubConfig.access_token = os.environ.get('GITHUB_ACCESS_TOKEN')
c.GitHubConfig.client_id = os.environ.get('GITHUB_CLIENT_ID')
c.GitHubConfig.client_secret = os.environ.get('GITHUB_CLIENT_SECRET')

# Persist hub data on volume mounted inside container
data_dir = os.environ.get('DATA_VOLUME_CONTAINER', '/data')

c.JupyterHub.cookie_secret_file = os.path.join(data_dir,
    'jupyterhub_cookie_secret')

c.JupyterHub.db_url = 'postgresql://postgres:{password}@{host}/{db}'.format(
    host=os.environ['POSTGRES_HOST'],
    password=os.environ['POSTGRES_PASSWORD'],
    db=os.environ['POSTGRES_DB'],
)

# services
c.JupyterHub.services = [
    {
        'name': 'cull-idle',
        'admin': True,
        'command': 'python cull_idle_servers.py --timeout={server_timeout_seconds}'.format(
            server_timeout_seconds=os.environ['SERVER_TIMEOUT_SECONDS']
            ).split(),

    }
]
# Do not comment out this line below!
c.ConfigurableHTTPProxy.auth_token = open('/etc/proxy_token','r').read().replace('\n','')

# Whitlelist users and admins
c.Authenticator.whitelist = whitelist = set()
c.Authenticator.admin_users = admin = set()
c.JupyterHub.admin_access = True
pwd = os.path.dirname(__file__)
with open(os.path.join(pwd, 'userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name = parts[0]
        whitelist.add(name)
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)
