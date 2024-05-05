# This is in test phase right now. Use at your own risk.
# This expects you to have postgreSQL installed already locally for test/dev

.PHONY: set-password create-database create-user grant-all-to-user check-status start-service stop-service restart-service drop_db drop_user reset_password list_databases list_users list_permissions

DB_USER ?= postgres
DB_PASSWORD ?= YourSuperStrongPassword
SERVICE = postgresql

PGHOST := localhost
PGPORT := 5432
PGUSER := postgres

# Define common command
PSQL_CMD := psql -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) -c




# Set the default password for the postgres user
set-password:
	@sudo -u $(DB_USER) $(PSQL_CMD) "ALTER USER $(DB_USER) WITH PASSWORD '$(DB_PASSWORD)';"
	@echo "Password for $(DB_USER) has been set."

# Create a new database
create-database:
	@read -p "Enter the database name: " dbname; \
	if sudo -u $(DB_USER) $(PSQL_CMD) "SELECT 1 FROM pg_database WHERE datname = '$$dbname';" | grep -q 1; then \
		echo "Database $$dbname already exists."; \
	else \
		sudo -u $(DB_USER) $(PSQL_CMD) "CREATE DATABASE $$dbname;" && echo "Database $$dbname created."; \
	fi

# Create a new user with a password
create-user:
	@read -p "Enter the new user name: " new_user; \
	read -p "Enter password for new user: " pass; \
	if sudo -u $(DB_USER) $(PSQL_CMD) "SELECT 1 FROM pg_catalog.pg_user WHERE usename = '$$new_user';" | grep -q 1; then \
		echo "User $$new_user already exists."; \
	else \
		sudo -u $(DB_USER) $(PSQL_CMD) "CREATE USER $$new_user WITH PASSWORD '$$pass';" && echo "User $$new_user created."; \
	fi

# Grant all permissions to a user on a database
grant-all-to-user:
	@read -p "Enter the database name: " dbname; \
	read -p "Enter the user to grant permissions to: " user; \
	if sudo -u $(DB_USER) $(PSQL_CMD) "SELECT 1 FROM pg_database WHERE datname = '$$dbname';" | grep -q 1; then \
		if sudo -u $(DB_USER) $(PSQL_CMD) "SELECT 1 FROM pg_catalog.pg_user WHERE usename = '$$user';" | grep -q 1; then \
			sudo -u $(DB_USER) $(PSQL_CMD) "GRANT ALL PRIVILEGES ON DATABASE $$dbname TO $$user;" && echo "Granted all privileges on database $$dbname to user $$user." || echo "Failed to grant privileges."; \
		else \
			echo "User $$user does not exist."; \
		fi \
	else \
		echo "Database $$dbname does not exist."; \
	fi

# Check the status of the PostgreSQL service
check-status:
	@sudo systemctl status $(SERVICE)

# Start the PostgreSQL service
start-service:
	@sudo systemctl start $(SERVICE)
	@echo "PostgreSQL service started."

# Stop the PostgreSQL service
stop-service:
	@sudo systemctl stop $(SERVICE)
	@echo "PostgreSQL service stopped."

# Restart the PostgreSQL service
restart-service:
	@sudo systemctl restart $(SERVICE)
	@echo "PostgreSQL service restarted."

# Drop a PostgreSQL database
drop_db:
	@read -p "Enter the database name: " dbname; \
	dropdb -h $(PGHOST) -p $(PGPORT) -U $(PGUSER) $$dbname

# Drop a PostgreSQL user
drop_user:
	@read -p "Enter the user name: " username; \
	$(PSQL_CMD) "DROP USER IF EXISTS $$username;"

# Reset password for a PostgreSQL user
reset_password:
	@read -p "Enter the user name: " username; \
	read -p "Enter new password: " new_password; \
	$(PSQL_CMD) "ALTER USER $$username WITH PASSWORD '$$new_password';"

# List PostgreSQL databases
list_databases:
	$(PSQL_CMD) -l

# List PostgreSQL users
list_users:
	$(PSQL_CMD) "SELECT * FROM pg_catalog.pg_user;"


# List Permissions
list_permissions:
	@read -p "Enter the user name: " username; \
	if sudo -u $(DB_USER) $(PSQL_CMD) "SELECT 1 FROM pg_catalog.pg_user WHERE usename = '$$username';" | grep -q 1; then \
		echo "Table-level privileges:"; \
		sudo -u $(DB_USER) $(PSQL_CMD) "SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.role_table_grants WHERE grantee = '$$username';" | awk -F'|' '{if (NF == 4) printf "User: %s, DB: %s, Table: %s, Privilege: %s\n", $$1, $$2, $$3, $$4}'; \
		echo "Database-level privileges:"; \
		sudo -u $(DB_USER) $(PSQL_CMD) "SELECT datname, acl FROM (SELECT datname, unnest(datacl) as acl FROM pg_database WHERE datacl IS NOT NULL) as da WHERE acl::text LIKE '%$$username%';" | awk -F'|' 'function translate_privileges(privs) {gsub(/C/, "CONNECT", privs); gsub(/T/, "TEMP", privs); gsub(/c/, "CREATE", privs); return privs;} {if (NF == 2) printf "DB: %s, Access Rights: %s by %s\n", $$1, translate_privileges($$2), $$2}'; \
	else \
		echo "User $$username does not exist."; \
	fi







