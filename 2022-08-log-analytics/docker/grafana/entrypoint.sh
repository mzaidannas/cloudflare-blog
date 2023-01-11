#!/bin/sh
set -e

mkdir -p /etc/grafana/provisioning/datasources
cat <<EOF > /etc/grafana/provisioning/datasources/ds.yaml
apiVersion: 1
datasources:
  - name: 'ClickHouse'
    type: 'grafana-clickhouse-datasource'
    isDefault: true
    jsonData:
      defaultDatabase: r0
      port: 9000
      server: clickhouse
      username: demouser
      tlsSkipVerify: false
    secureJsonData:
      password: 239QV8JkGmF9AZM
    editable: true
EOF
mkdir -p /etc/grafana/provisioning/dashboards
cat <<EOF > /etc/grafana/provisioning/dashboards/dashboard.yaml
apiVersion: 1
providers:
  - name: demo-logs
    type: file
    updateIntervalSeconds: 30
    options:
      path:  /var/lib/grafana/dashboards
      foldersFromFilesStructure: true
EOF
/run.sh
