FROM ubuntu:14.04
MAINTAINER Luis Triana <luis.triana@jarsa.com.mx>
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
RUN apt-get update -q && apt-get safe-upgrade -q && \
    apt-get install --allow-unauthenticated -q
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN apt-get update -q && apt-get safe-upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    fontconfig \
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
    python \
    python-dev \
    xfonts-75dpi \
    xfonts-base
RUN cd /tmp && wget -O wkhtmltox-0.12.1_linux-trusty-amd64.deb http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb \
    && dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g less less-plugin-clean-css
RUN cd /tmp && wget -q https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py && python get-pip.py
RUN cd /tmp && wget -q https://raw.githubusercontent.com/odoo/odoo/8.0/requirements.txt && pip install -r requirements.txt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
RUN adduser --home=/home/odoo --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo' |chpasswd
ADD files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD files/logrotate /etc/logrotate.d/odoo-server
RUN chmod 755 /etc/logrotate.d/odoo-server
RUN mkdir -p /var/log/odoo && \
    chown odoo:root /var/log/odoo
VOLUME ["/home/odoo/", "/var/log/odoo"]
USER odoo
CMD /entrypoint.sh
EXPOSE 8069 8072