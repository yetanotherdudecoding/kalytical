In order to login and push images, enable HTTP connection, then tick box for basic authentication and ALLOW V1 PROTCOL
Create raw artifact repository
curl -v -u admin:admin123 --upload-file streamsets-datacollector-all-3.6.0.tgz  http://localhost:8081/repository/raw-artifacts/oss/streamsets-datacollector-all-3.6.0.tgz
XGET will retrieve this artifact
