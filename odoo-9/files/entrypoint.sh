#!/bin/bash
/opt/odoo/odoo.py \
-c /opt/odoo/odoo-server.conf \
--db_host=$DB_PORT_5432_TCP_ADDR
exec "$@"