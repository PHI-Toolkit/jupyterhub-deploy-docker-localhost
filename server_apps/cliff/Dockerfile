FROM tomcat:9.0.27-jdk11-openjdk
ARG CLIFF_VERSION

ENV CLIFF_VERSION ${CLIFF_VERSION}

MAINTAINER John Beieler <johnb30@gmail.com>
LABEL cliff-releases https://github.com/mitmedialab/CLIFF/releases
LABEL revised-by herman.tolentino@gmail.com

COPY ./server_apps/cliff/. /src
RUN sed -i "s/httpredir.debian.org/`curl -s -D - http://httpredir.debian.org/demo/debian/ | awk '/^Link:/ { print $2 }' | sed -e 's@<http://\(.*\)/debian/>;@\1@g'`/" /etc/apt/sources.list
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends git maven
RUN cd; curl https://github.com/c4fcm/CLIFF/releases/download/v${CLIFF_VERSION}/CLIFF-${CLIFF_VERSION}.war -o /usr/local/tomcat/webapps/CLIFF-${CLIFF_VERSION}.war

EXPOSE 8080

RUN chmod -x /src/launch.sh
CMD sh /src/launch.sh
