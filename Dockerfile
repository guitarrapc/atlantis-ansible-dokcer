FROM runatlantis/atlantis:v0.9.0

# python3 and ansible
RUN set -ex && \
    apk add --no-cache build-base python3-dev libffi-dev openssl-dev && \
    pip3 install --upgrade pip && \
    pip3 install ansible && \
    apk del build-base libffi-dev openssl-dev

RUN set -ex && \
    apk add --no-cache jq

RUN set -ex && \
    apk update && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make linux-headers && \
    pip3 --no-cache-dir install azure-cli && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apk del build gcc make

RUN set -ex && \
    curl -L -o /usr/local/bin/kubergrunt https://github.com/gruntwork-io/kubergrunt/releases/download/v0.5.4/kubergrunt_linux_amd64 && \
    chmod +x /usr/local/bin/kubergrunt

WORKDIR /home/atlantis

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["server", "--allow-repo-config"]
