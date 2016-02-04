Odoo 9.0
========

This docker image is for Odoo 9.0

To run this image you must run Postgres docker image from:

    docker run --restart=always --name db -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=odoo -d postgres:9.5

After the download process is completed you can run the container with:

    docker run -P --restart=always --name odoo-9.0 --link db:db -v path-to-odoo:/opt/odoo -p 0.0.0.0:8069:8069 -p 0.0.0.0:8072:8072 -d jarsa/odoo:9.0

Where path-to-odoo must have:
    
    Odoo folder called 9.0
    odoo-server.conf