FROM registry.access.redhat.com/rhel7

MAINTAINER Luigi De Masi <luigidemasi@gmail.com>

LABEL name="ldm/grafana-arbitrary-uid" \
      vendor="Grafana" \
      version="4.3.3" \
      release="1" \
      summary="Grafana is an open source metric analytics & visualization suite" \
      description="It is most commonly used for visualizing time series data for infrastructure and application analytics but many use it in other domains including industrial sensors, home automation, weather, and process control." \
### Required labels above - recommended below
      url="https://grafana.com" \
      io.k8s.description="Grafana is an open source metric analytics & visualization suite" \
      io.k8s.display-name="Grafana" \
      io.openshift.expose-services="" \
io.openshift.tags="grafana,monitoring,visualization,starter-arbitrary-uid,starter,arbitrary,uid"

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

RUN curl -O   https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.4.3.linux-x64.tar.gz && \
    tar -xvf grafana-4.4.3.linux-x64.tar.gz && \
    mv grafana-4.4.3 grafana && \
    mkdir {/var/lib/grafana,/var/log/grafana, /etc/grafana} && \
    chgrp -R 0 /var/lib/grafana /var/log/grafana /etc/grafana && \
    chmod -R g=u /some/directory && \
    chmod g=u /etc/passwd

ENTRYPOINT ["/run.sh"]

USER 1001
