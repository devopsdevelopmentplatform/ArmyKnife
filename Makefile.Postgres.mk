# Makefile for PostgreSQL administration

# Define PostgreSQL connection parameters
PGHOST := localhost
PGPORT := 5432
PGUSER := postgres

# Define common commands
CREATE_USER_CMD := psql -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) -c
CREATE_DB_CMD := createdb -h $(PGHOST) -p $(PGPORT) -U $(PGUSER)
GRANT_PERMISSIONS_CMD := psql -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) -c

# Define targets
.PHONY: create_user create_db grant_permissions

# Target: create a new PostgreSQL user
create_user:
	$(CREATE_USER_CMD) "CREATE USER $(USERNAME) WITH PASSWORD '$(PASSWORD)';"

# Target: create a new PostgreSQL database
create_db:
	$(CREATE_DB_CMD) $(DBNAME)

# Target: grant all permissions on a database to a user
grant_permissions:
	$(GRANT_PERMISSIONS_CMD) "GRANT ALL PRIVILEGES ON DATABASE $(DBNAME) TO $(USERNAME);"

# Target: drop a PostgreSQL database
drop_db:
	dropdb -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) $(DBNAME)

# Target: drop a PostgreSQL user
drop_user:
	$(CREATE_USER_CMD) "DROP USER IF EXISTS $(USERNAME);"

# Target: reset password for a PostgreSQL user
reset_password:
	$(CREATE_USER_CMD) "ALTER USER $(USERNAME) WITH PASSWORD '$(PASSWORD)';"

# Target: list PostgreSQL databases
list_databases:
	$(CREATE_DB_CMD) -l

# Target: list PostgreSQL users
list_users:
	$(CREATE_USER_CMD) "SELECT * FROM pg_catalog.pg_user;"

# Target: list granted permissions on a database
list_permissions:
	$(GRANT_PERMISSIONS_CMD) "SELECT * FROM information_schema.role_table_grants WHERE grantee='$(USERNAME)';"

