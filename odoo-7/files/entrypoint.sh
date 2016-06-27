#!/bin/bash
/opt/odoo/7.0/openerp-server \
-c /opt/odoo/odoo-server.conf \
--db_host=$DB_PORT_5432_TCP_ADDR 

exec "$@"