docker-compose stop && docker-compose rm -f && docker volume prune -f && git pull
docker volume rm  openmetadata_es-data openmetadata_ingestion-volume-dag-airflow openmetadata_ingestion-volume-dags openmetadata_ingestion-volume-tmp
