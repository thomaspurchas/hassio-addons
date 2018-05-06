ARG BUILD_FROM=hassioaddons/base-amd64:1.3.3
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache influxdb --repository http://dl-3.alpinelinux.org/alpine/edge/testing

# Copy data
COPY run.sh /
COPY influxdb.conf /etc/influxdb
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
