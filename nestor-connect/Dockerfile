ARG BUILD_FROM
FROM $BUILD_FROM

# Installation de FRP client
ENV FRP_VERSION 0.68.1
RUN apk add --no-cache wget \
    && arch=$(uname -m) \
    && if [ "$arch" = "x86_64" ]; then export FRP_ARCH="amd64"; \
       elif [ "$arch" = "aarch64" ]; then export FRP_ARCH="arm64"; \
       fi \
    && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${FRP_ARCH}.tar.gz \
    && tar -zxf frp_${FRP_VERSION}_linux_${FRP_ARCH}.tar.gz \
    && mv frp_${FRP_VERSION}_linux_${FRP_ARCH}/frpc /usr/bin/ \
    && rm -rf frp_${FRP_VERSION}_linux_${FRP_ARCH}*

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]