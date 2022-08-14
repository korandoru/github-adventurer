#!/usr/bin/env bash

# Copyright 2022 Korandoru Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o nounset

: "$CLICKHOUSE_BIN"
: "$CLICKHOUSE_HOST"
: "$CLICKHOUSE_PORT"
: "$CLICKHOUSE_RO_USER"
: "$CLICKHOUSE_RO_PASSWORD"

${CLICKHOUSE_BIN} client \
    --host ${CLICKHOUSE_HOST} \
    --port ${CLICKHOUSE_PORT} \
    --user ${CLICKHOUSE_RO_USER} \
    --password ${CLICKHOUSE_RO_PASSWORD} \
    -q "WITH (SELECT MAX(file_time) FROM github_events) as last SELECT toString(toDate(toDateTime(last + INTERVAL arrayJoin(range(1, 24)) HOUR, 'UTC') AS t)) || '-' || toString(toHour(t)) || '.json.gz' WHERE t < now()" \
| xargs -I{} bash -c "wget --continue 'https://data.gharchive.org/{}'"

echo "Downloaded:"
echo "$(ls *.json.gz)"
