#!/bin/bash

CLICKHOUSE_DB="${CLICKHOUSE_DB:-database}";
CLICKHOUSE_USER="${CLICKHOUSE_USER:-user}";
CLICKHOUSE_PASSWORD="${CLICKHOUSE_PASSWORD:-password}";

cat <<EOT > /etc/clickhouse-server/users.d/user.xml
<yandex>
  <!-- Docs: <https://clickhouse.tech/docs/en/operations/settings/settings_users/> -->
  <users>
    <${CLICKHOUSE_USER}>
      <profile>default</profile>
      <networks>
        <ip>::/0</ip>
      </networks>
      <password>${CLICKHOUSE_PASSWORD}</password>
      <quota>default</quota>
    </${CLICKHOUSE_USER}>
  </users>
</yandex>
EOT
#cat /etc/clickhouse-server/users.d/user.xml;

cat <<EOT > /etc/clickhouse-server/config.d/s3_storage_config.xml
<clickhouse>
  <!-- Docs: https://clickhouse.com/docs/en/guides/sre/configuring-s3-for-clickhouse-use/> -->
  <storage_configuration>
    <disks>
      <s3_disk>
        <type>s3</type>
        <endpoint>${S3_PATH}</endpoint>
        <access_key_id>${AWS_ACCESS_KEY_ID}</access_key_id>
        <secret_access_key>${AWS_SECRET_ACCESS_KEY}</secret_access_key>
        <metadata_path>/var/lib/clickhouse/disks/s3_disk/</metadata_path>
        <cache_enabled>true</cache_enabled>
        <data_cache_enabled>true</data_cache_enabled>
        <cache_path>/var/lib/clickhouse/disks/s3_disk/cache/</cache_path>
      </s3_disk>
    </disks>
    <policies>
      <s3_main>
        <volumes>
          <main>
            <disk>s3_disk</disk>
          </main>
        </volumes>
      </s3_main>
    </policies>
  </storage_configuration>
</clickhouse>
EOT


clickhouse-client --query "CREATE DATABASE IF NOT EXISTS ${CLICKHOUSE_DB}";

echo -n '
CREATE TABLE IF NOT EXISTS r0.logs
(
    `id` UInt64,
    `bytes` UInt8,
    `event_time`  DateTime,
    `host` String,
    `method` String,
    `protocol` String,
    `referer` String,
    `request` String,
    `status` String,
    `user-identifier` String,
    `body` String
)
ENGINE = MergeTree
PARTITION BY toStartOfHour(event_time)
ORDER BY (event_time)
SETTINGS storage_policy = '\'s3_main\'', index_granularity = 8192
;' | clickhouse-client
