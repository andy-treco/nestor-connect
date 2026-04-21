ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# Installation des dépendances (version Debian car ton exemple utilisait apt-get)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates tar \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installation du binaire FRP (0.68.1)
RUN arch=$(uname -m) && \
    if [ "$arch" = "x86_64" ]; then FRP_ARCH="amd64"; \
    elif [ "$arch" = "aarch64" ]; then FRP_ARCH="arm64"; \
    else FRP_ARCH="armv7"; fi && \
    wget https://github.com/fatedier/frp/releases/download/v0.68.1/frp_0.68.1_linux_${FRP_ARCH}.tar.gz && \
    tar -zxf frp_0.68.1_linux_${FRP_ARCH}.tar.gz && \
    mv frp_0.68.1_linux_${FRP_ARCH}/frpc /usr/bin/ && \
    rm -rf frp_0.68.1_linux_${FRP_ARCH}*

# On copie tout le contenu de ton dossier rootfs local vers la racine du conteneur
COPY rootfs/ /

# On rend le script exécutable (en utilisant TON nom de dossier)
# Et on nettoie les caractères Windows (\r) au cas où
RUN chmod a+x /etc/services.d/nestor-connect/run \
    && sed -i 's/\r$//' /etc/services.d/nestor-connect/run

# Pas d'ENTRYPOINT, le superviseur HA s'occupe de tout via /init
