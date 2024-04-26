FROM ubuntu:18.04
MAINTAINER Luis Triana <luis.triana@jarsa.com.mx>

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf
RUN apt-get update \
    && apt-get install sudo gnupg language-pack-es -y \
    && locale-gen "en_US.UTF-8" "fr_FR.UTF-8"
ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    PYTHONIOENCODING="UTF-8" TERM="xterm" DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    wget
RUN echo 'deb https://apt-archive.postgresql.org/pub/repos/apt bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN echo 'deb http://security.ubuntu.com/ubuntu xenial-security main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt install aptitude build-essential curl fontconfig git nano openssh-server postgresql-11 postgresql-client-11 postgresql-contrib-11 postgresql-server-dev-11 python3 python3-pip python3-dev python3-renderpm libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libxrender1 xfonts-75dpi xfonts-base libpq-dev -y

# Install wkhtmltopdf
RUN cd /tmp && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb

# Download and install odoo requirements from github.com/odoo/odoo/requirements.txt
RUN cd /tmp && \
    wget -q https://raw.githubusercontent.com/odoo/odoo/14.0/requirements.txt && \
    pip3 install -r requirements.txt && pip3 install --upgrade pip

#Python Libraries
RUN pip3 install vobject qrcode pyldap num2words phonenumbers pyldap slugify vobject watchdog xlrd xlwt

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Add ODOO user
RUN adduser --home=/home/odoo-14.0/ --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo**' | chpasswd
RUN echo "odoo ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Create odoo-server.conf
ADD files/odoo-server.conf /home/odoo-14.0/odoo-server.conf
RUN chown odoo /home/odoo-14.0/odoo-server.conf && \
    chmod +x /home/odoo-14.0/odoo-server.conf

#Install Odoo
RUN cd /home/odoo-14.0/ && git clone -b 14.0 --single-branch --depth=1 https://github.com/odoo/odoo.git odoo
RUN chmod +x /home/odoo-14.0/odoo
RUN mkdir -p /home/odoo-14.0/.local/share/Odoo/filestore && \
    chown -R odoo:odoo /home/odoo-14.0/.local/share/Odoo/filestore

#Odoo Log
RUN mkdir -p /home/odoo-14.0/.local/log/Odoo && \
    touch /home/odoo-14.0/.local/log/Odoo/odoo-server.log && \
    chown odoo: -R /home/odoo-14.0/.local/log/Odoo && \
    chmod -R 777 /home/odoo-14.0/.local/log/Odoo/odoo-server.log

#Volume for Odoo files
RUN mkdir -p /home/odoo-14.0/extra-addons \
        && chown -R odoo:odoo /home/odoo-14.0/extra-addons && \
        chown -R odoo:odoo /home/odoo-14.0/
VOLUME ["/home/odoo-14.0/"]

#Make service for Odoo
ADD files/odoo-server /etc/init.d/odoo-server
RUN chmod 755 /etc/init.d/odoo-server
RUN chown root: /etc/init.d/odoo-server

# Correct error with ssl-cert permissions for Postgres
RUN mkdir /etc/ssl/private-copy && \
    mv /etc/ssl/private/* /etc/ssl/private-copy/ && \
    rm -r /etc/ssl/private && \
    mv /etc/ssl/private-copy /etc/ssl/private && \
    chmod -R 0700 /etc/ssl/private && \
    chown -R postgres /etc/ssl/private

USER postgres

# Run Postgres Server
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER odoo WITH SUPERUSER PASSWORD 'odoo';"

USER odoo

CMD /bin/bash

EXPOSE 8069
EXPOSE 8072
EXPOSE 22
EXPOSE 5432
