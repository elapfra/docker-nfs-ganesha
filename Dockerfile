FROM ubuntu:24.04
LABEL maintainer="jan@rancher.com"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nfs-ganesha \
    nfs-ganesha-vfs \
    nfs-common \
    rpcbind \
    dbus && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /proc/self/mounts /etc/mtab

# Add Tini
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.sha256sum /tini.sha256sum
RUN sha256sum -c /tini.sha256sum && \
    rm /tini.sha256sum && \
    chmod +x /tini

COPY rootfs /

VOLUME ["/data/nfs"]

# NFS ports
EXPOSE 111 111/udp 662 2049 38465-38467

ENTRYPOINT ["/tini", "--"]
CMD ["/opt/start_nfs.sh"]
