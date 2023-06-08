FROM grafana/grafana

WORKDIR /tmp
USER root

RUN apk add curl unzip

RUN curl -vkL https://github.com/grafana/clickhouse-datasource/releases/download/v3.1.0/grafana-clickhouse-datasource-3.1.0.linux_amd64.zip -o grafana-clickhouse-datasource-3.1.0.linux_amd64.zip

RUN unzip grafana-clickhouse-datasource-3.1.0.linux_amd64.zip -d /var/lib/grafana/plugins/

COPY dashboards/demo-logs.json /var/lib/grafana/dashboards/

COPY docker/grafana/entrypoint.sh /entrypoint.sh
