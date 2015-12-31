#!/bin/bash
mkdir -p /home/odoo/.local/share/Odoo/filestore
chown -r odoo /home/odoo
/home/odoo/odoo/odoo.py \
-c /home/odoo/odoo-server.conf
exec "$@"