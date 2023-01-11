FROM grafana/grafana:9.3.2

WORKDIR /tmp
USER root

RUN apk add curl unzip

RUN curl -vkL https://github.com/grafana/clickhouse-datasource/releases/download/v2.0.6/grafana-clickhouse-datasource-2.0.6.linux_amd64.zip -o grafana-clickhouse-datasource-2.0.6.linux_amd64.zip

RUN unzip grafana-clickhouse-datasource-2.0.6.linux_amd64.zip -d /var/lib/grafana/plugins/

COPY dashboards/demo-logs.json /var/lib/grafana/dashboards/

COPY docker/grafana/entrypoint.sh /entrypoint.sh
