#!/bin/bash
/opt/odoo/8.0/odoo.py \
-c /opt/odoo/odoo-server.conf \
--db_user=$DB_ENV_POSTGRES_USER \
--db_password=$DB_ENV_POSTGRES_PASSWORD \
--db_host=$DB_PORT_5432_TCP_ADDR \

exec "$@