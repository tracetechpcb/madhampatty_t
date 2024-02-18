-- init-db.sql
-- Allows root user to access the db from any host and not jsut localhost

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'tracetech' WITH GRANT OPTION;
FLUSH PRIVILEGES;