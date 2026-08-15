FROM influxdb:3-core

RUN apt update && apt install -y jq envsubst; rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y cron grep; rm -rf /var/lib/apt/lists/*

COPY ./backup.sh /backup.sh
RUN chmod +x /backup.sh

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD ["/usr/bin/entrypoint.sh", "influxdb", "serve"]