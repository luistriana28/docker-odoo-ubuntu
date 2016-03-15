Odoo 7
===========

This docker image is for Odoo 7.0.

To run this image you must run Postgres docker image from:

    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=odoo -d postgres:9.5

After the download process is completed you can run the container with:

    docker run --name some-odoo --link some-postgres:db -p 0.0.0.0:8069:8069 -d xluiisx/odoo-7