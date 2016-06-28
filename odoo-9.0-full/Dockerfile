FROM ubuntu:14.04
MAINTAINER LuisTriana <luis.triana@jarsa.com.mx>

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf
RUN locale-gen fr_FR \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && update-locale LANG=en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8
RUN ln -s /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/all \
    && locale-gen
ENV PYTHONIOENCODING utf-8
ENV TERM xterm
#Install Odoo dependencies
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    wget
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    antiword \
    bash-completion \
    fontconfig \
    git \
    libevent-dev \
    libjpeg-dev \
    libldap2-dev \
    libsasl2-dev \
    libx11-6 \
    libxext6 \
    libxml2-dev \
    libxrender1 \
    libxslt-dev \
    nano \
    npm \
    postgresql-server-dev-9.4 \
    postgresql-9.4 \
    postgresql-client-9.4 \
    postgresql-contrib-9.4 \
    supervisor \
    python-software-properties \
    software-properties-common \
    postgresql-common \
    python-psycopg2 \
    python \
    python-dev \
    xfonts-75dpi \
    xfonts-base
    openssl \
    python \
    python-dev \
    python-imaging \
    python-libxml2 \
    python-pandas \
    python-qrtools \
    xfonts-75dpi \
    xfonts-base \
    swig \
    xmlstarlet \
    xsltproc 
# Install wkhtmltopdf
RUN cd /tmp && \
    wget -O wkhtmltox-0.12.1_linux-trusty-amd64.deb http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb

# Install nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g less less-plugin-clean-css

# Install pip
RUN cd /tmp && \
    wget -q https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py

# Install external pip dependencies
RUN pip install  SOAPpy suds xmltodict simplejson M2Crypto

# Download and install odoo requirements from github.com/odoo/odoo/requirements.txt
RUN cd /tmp && wget -q https://raw.githubusercontent.com/odoo/odoo/9.0/requirements.txt && pip install -r requirements.txt

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Add user
RUN adduser --home=/opt/odoo --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo' |chpasswd

# Create entrypoint
ADD files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chown -R odoo:odoo /entrypoint.sh

# Create odoo-server.conf
ADD files/odoo-server.conf /opt/odoo/odoo-server.conf
RUN chmod +x /odoo-serve.conf

# Create odoo-server.conf
RUN mkdir -p /opt/odoo
ADD files/odoo-server.conf /odoo-sever.conf


# Add Logrotate file
ADD files/logrotate /etc/logrotate.d/odoo-server
RUN chmod 755 /etc/logrotate.d/odoo-server

# Add log directory
RUN mkdir -p /var/log/odoo && \
    chown odoo:root /var/log/odoo

# Add filestorage folder
RUN /bin/bash -c "mkdir -p /home/odoo/filestorage"
RUN chown odoo /home/odoo/filestorage

VOLUME ["opt/odoo", "/var/log/odoo", "/home/odoo/filestorage"]

RUN echo $'#!/bin/bash\nchown -R odoo:odoo /opt/odoo && chmod 640 /opt/odoo/odoo-server.conf' > /permission.sh && chmod +x /permission.sh
CMD /permission.sh

USER odoo
CMD /entrypoint.sh

EXPOSE 8069
EXPOSE 8072
EXPOSE 22