#!/bin/bash -e

mkdir -p ${DATA_DIR}
if [[ ! -s ${DATA_DIR}/aeternity.yaml ]]; then
    cat <<EOF > ${DATA_DIR}/aeternity.yaml
---
sync:
    port: ${PORT}

keys:
    dir: keys
    peer_password: "secret"

http:
    external:
        port: ${PORT_HTTP_EXTERNAL}
    internal:
        port: ${PORT_HTTP_INTERNAL}

websocket:
    channel:
        port: ${PORT_SOCKET}

mining:
    autostart: false

chain:
    persist: true
    db_path: ./my_db

fork_management:
    network_id: ${NETWORK_ID}

EOF

fi

exec "$@"