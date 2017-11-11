FROM resin/rpi-raspbian:stretch

ENV VERSION v0.14.40

RUN echo 'syncthing:x:1000:1000::/var/syncthing:/sbin/nologin' >> /etc/passwd \
    && echo 'syncthing:!::0:::::' >> /etc/shadow \
    && mkdir /var/syncthing \
    && chown syncthing /var/syncthing

RUN set -x \
    && apt-get update  \
    && apt-get dist-upgrade -y \
    && apt-get install -y wget xmlstarlet ca-certificates \
    && mkdir /syncthing \
    && cd /syncthing \
    && wget https://github.com/syncthing/syncthing/releases/download/${VERSION}/syncthing-linux-arm-$VERSION.tar.gz  \
    && wget https://github.com/syncthing/syncthing/releases/download/${VERSION}/sha256sum.txt.asc \
    && gpg --verify sha256sum.txt.asc \
    && grep syncthing-linux-arm sha256sum.txt.asc | sha256sum \
    && tar -xvf syncthing-linux-arm-${VERSION}.tar.gz \
    && mv syncthing-linux-arm-${VERSION}/syncthing . \
    && rm -rf syncthing-linux-arm-${VERSION} sha256sum.txt.asc syncthing-linux-arm-${VERSION}.tar.gz \
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && apt-get clean

USER syncthing
ENV STNOUPGRADE=1
ENTRYPOINT ["/syncthing/syncthing", "-home", "/var/syncthing/config", "-gui-address", "0.0.0.0:8384"]
EXPOSE 8384 22000 21025/udp
