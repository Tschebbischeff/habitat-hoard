FROM influxdb:3-core

RUN apt update && apt install -y jq envsubst; rm -rf /var/lib/apt/lists/*

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD ["/usr/bin/entrypoint.sh", "influxdb", "serve"]