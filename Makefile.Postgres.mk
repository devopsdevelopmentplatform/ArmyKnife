# This is in test phase right now. Use at your own risk.
# This expects you to have postgreSQL installed already locally for test/dev

.PHONY: set-password grant-permissions check-status start-service stop-service restart-service create-database create-user grant-all-to-user

DB_USER ?= postgres
DB_PASSWORD ?= YourSuperStrongPassword
SERVICE = postgresql

# Set the default password for the postgres user
set-password:
	@sudo -u $(DB_USER) psql -c "ALTER USER $(DB_USER) WITH PASSWORD '$(DB_PASSWORD)';"
	@echo "Password for $(DB_USER) has been set."

# Create a new database
create-database:
	@read -p "Enter the database name: " dbname; \
	sudo -u $(DB_USER) psql -c "CREATE DATABASE $$dbname;" && echo "Database $$dbname created."
	

# Create a new user with a password
create-user:
	@read -p "Enter the new user name: " new_user; \
	read -p "Enter password for new user: " pass; \
	sudo -u $(DB_USER) psql -c "CREATE USER $$new_user WITH PASSWORD '$$pass';" && echo "User $$new_user created."

# Grant all permissions to a user on a database
grant-all-to-user:
	@read -p "Enter the database name: " dbname; \
	read -p "Enter the user to grant permissions to: " user; \
	sudo -u $(DB_USER) psql -c "GRANT ALL PRIVILEGES ON DATABASE $$dbname TO $$user;" && echo "Granted all privileges on database $$dbname to user $$user."
	

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

