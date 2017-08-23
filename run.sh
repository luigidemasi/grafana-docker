#!/usr/bin/env bash

: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"


if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-grafana}:x:$(id -u):0:${USER_NAME:-grafana} user:${HOME:-/grafana}:/sbin/nologin" >> /etc/passwd
  fi
fi


if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    IFS=$OLDIFS
    grafana-cli  --pluginsDir "${GF_PATHS_PLUGINS}" plugins install ${plugin}
  done
fi

  exec ${GRAFANA_ROOT}/bin/grafana-server       \
  --homepath=/usr/share/grafana                 \
  --config=/etc/grafana/grafana.ini             \
  cfg:default.log.mode="console"                \
  cfg:default.paths.data="$GF_PATHS_DATA"       \
  cfg:default.paths.logs="$GF_PATHS_LOGS"       \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS" \
  "$@"
