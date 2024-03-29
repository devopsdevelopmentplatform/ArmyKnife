.PHONY: start stop status cluster_health shard_health node_performance

start:
	@echo "Starting ELK services..."
	# Add your start commands here (systemctl or docker-compose)
	# I'm using Bitnami ELK stack. They have a script to restart the services etc.

stop:
	@echo "Stopping ELK services..."
	# Add your stop commands here (systemctl or docker-compose)
	# I'm using Bitnami ELK stack. They have a script to restart the services etc.

status:
	@echo "Checking status of ELK services..."
	# Add your status commands here (systemctl, docker ps, or docker-compose)
	# I'm using Bitnami ELK stack. They have a script to restart the services etc.

cluster_health:
	@echo "Checking cluster health..."
	@curl -X GET "localhost:9200/_cluster/health?pretty"

shard_health:
	@echo "Checking for unassigned shards..."
	@curl -X GET "localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason&pretty"

node_performance:
	@echo "Checking node performance..."
	@curl -X GET "localhost:9200/_nodes/stats/jvm,process?pretty"
	@echo "Checking cluster stats..."
	@curl -X GET "localhost:9200/_cluster/stats?human&pretty"
