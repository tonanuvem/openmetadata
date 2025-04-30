from metadata.ingestion.ometa.ometa_api import OpenMetadata
from metadata.generated.schema.entity.services.connections.metadata.openMetadataConnection import (
    OpenMetadataConnection, AuthProvider,
)
from metadata.generated.schema.security.client.openMetadataJWTClientConfig import OpenMetadataJWTClientConfig

server_config = OpenMetadataConnection(
    hostPort="http://localhost:8585/api",
    authProvider=AuthProvider.openmetadata,
    securityConfig=OpenMetadataJWTClientConfig(
        jwtToken="eyJraWQiOiJHYjM4OWEtOWY3Ni1nZGpzLWE5MmotMDI0MmJrOTQzNTYiLCJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9",
    ),
)
metadata = OpenMetadata(server_config)

from metadata.generated.schema.api.services.createDatabaseService import (
    CreateDatabaseServiceRequest,
)
from metadata.generated.schema.entity.services.databaseService import (
    DatabaseService,
    DatabaseServiceType,
    DatabaseConnection,
)
from metadata.generated.schema.entity.services.connections.database.common.basicAuth import (
    BasicAuth,
)
from metadata.generated.schema.entity.services.connections.database.mysqlConnection import (
    MysqlConnection,
)

create_service = CreateDatabaseServiceRequest(
    name="mysql-service-table",
    serviceType=DatabaseServiceType.Mysql,
    connection=DatabaseConnection(
        config=MysqlConnection(
            username="root",
            authType=BasicAuth(password="admin"),
            hostPort="http://35.173.236.137:3306",
        )
    ),
)

print("create_service.json():")
create_service.json()
# '{"name": "test-service-table", "description": null, "serviceType": "Mysql", "connection": {"config": {"type": "Mysql", "scheme": "mysql+pymysql", "username": "username", "password": "**********", "hostPort": "http://localhost:1234", "database": null, "connectionOptions": null, "connectionArguments": null, "supportsMetadataExtraction": null, "supportsProfiler": null}}, "owner": null}'

print("service_entity = metadata.create_or_update(data=create_service:")
service_entity = metadata.create_or_update(data=create_service)

print("type:")


type(service_entity)
# metadata.generated.schema.entity.services.databaseService.DatabaseService

service_entity.json()
