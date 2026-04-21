ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

RUN apk add --no-cache wget ca-certificates tar

RUN arch=$(uname -m) && \
    if [ "$arch" = "x86_64" ]; then FRP_ARCH="amd64"; \
    elif [ "$arch" = "aarch64" ]; then FRP_ARCH="arm64"; \
    else FRP_ARCH="armv7"; fi && \
    wget https://github.com/fatedier/frp/releases/download/v0.68.1/frp_0.68.1_linux_${FRP_ARCH}.tar.gz && \
    tar -zxf frp_0.68.1_linux_${FRP_ARCH}.tar.gz && \
    mv frp_0.68.1_linux_${FRP_ARCH}/frpc /usr/bin/ && \
    rm -rf frp_0.68.1_linux_${FRP_ARCH}*

COPY rootfs/ /

# On rend le script exécutable
RUN chmod a+x /etc/services.d/nestor-connect/run \
    && sed -i 's/\r$//' /etc/services.d/nestor-connect/run

# --- LES DEUX LIGNES MAGIQUES POUR NETTOYER LE CACHE ---
ENTRYPOINT []
CMD []
