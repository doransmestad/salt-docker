FROM        bitnami/minideb:latest
MAINTAINER  Frederic Perrouin "frederic@fredprod.com"
ENV REFRESHED_AT 2017-01-12

# Update system
RUN install_packages wget sudo procps

# Add Salt Jessie repository
RUN echo deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main | tee /etc/apt/sources.list.d/saltstack.list 
RUN wget -qO - http://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

# Install salt master/minion/cloud/api
RUN apt-get update
RUN install_packages salt-master salt-minion salt-cloud salt-api

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor /etc/salt/master.d/reactor

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/log/salt", "/srv/salt"]

# Exposing salt master and api ports
EXPOSE 4505 4506 8080 8081

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
