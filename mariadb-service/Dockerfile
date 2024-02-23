# Use the official MariaDB image as the base
FROM mariadb:10.6

# Copy initialization script so that it runs on startup
COPY ./mariadb-service/init-db.sql /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sql
