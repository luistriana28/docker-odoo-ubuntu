Odoo 9.0
========

This docker image is for Odoo 9.0

After the download process is completed you can run the container with:

    docker run -P --restart=always --name odoo-9.0 --link db:db -v path-to-odoo:/opt/odoo -p 0.0.0.0:100:8069 -p 0.0.0.0:102:8072 -d xluiisx