FROM golang:alpine

# Install yq for YAML and JSON parsing
RUN apk add -U curl git jq && \
    wget -q -O /usr/bin/yq $(wget -q -O - https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.assets[] | select(.name == "yq_linux_amd64") | .browser_download_url') && \
    chmod +x /usr/bin/yq

# Install doctl
RUN export DOCTL_VERSION="$(curl https://github.com/digitalocean/doctl/releases/latest -s -L -I -o /dev/null -w '%{url_effective}' | awk '{n=split($1,A,"/v"); print A[n]}')" && \
    curl -sL https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VERSION/doctl-$DOCTL_VERSION-linux-amd64.tar.gz | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/doctl

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
