#!/bin/sh
set -x

chown -R ${USERNAME} .

exec su-exec ${USERNAME} "$@"
