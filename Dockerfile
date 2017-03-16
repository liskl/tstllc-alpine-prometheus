FROM registry.tstllc.net/llisk/alpine-base:latest

# Dev-Ops Team
MAINTAINER dl_team_devops@tstllc.net

RUN apk update;
RUN apk add --no-cache --virtual .build-dependencies "openssl" "curl"; \
    curl -skL "https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.linux-amd64.tar.gz" -o "/tmp/prometheus-1.5.2.linux-amd64.tar.gz"; \
    cd "/tmp"; \
    tar xzf "/tmp/prometheus-1.5.2.linux-amd64.tar.gz" && \
    mkdir -p "/prometheus" && \
    mkdir -p "/etc/prometheus" && \ 
    mv "/tmp/prometheus-1.5.2.linux-amd64/prometheus" "/bin/prometheus" && \
    mv "/tmp/prometheus-1.5.2.linux-amd64/promtool" "/bin/promtool" && \
    mv "/tmp/prometheus-1.5.2.linux-amd64/prometheus.yml" "/etc/prometheus/prometheus.yml" && \
    mv "/tmp/prometheus-1.5.2.linux-amd64/console_libraries" "/etc/prometheus/" && \
    mv "/tmp/prometheus-1.5.2.linux-amd64/consoles" "/etc/prometheus/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/prometheus-1.5.2.linux-amd64/" "/tmp/prometheus-1.5.2.linux-amd64.tar.gz";
    
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "-config.file=/etc/prometheus/prometheus.yml", \
             "-storage.local.path=/prometheus", \
             "-web.console.libraries=/etc/prometheus/console_libraries", \
             "-web.console.templates=/etc/prometheus/consoles" ]
