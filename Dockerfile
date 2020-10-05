FROM debian:stable-slim

RUN echo "deb http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list

RUN apt-get -y update \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -t buster-backports install -y --no-install-recommends \
    ca-certificates \
    ldap-utils \
    libsasl2-modules \
    libsasl2-modules-db \
    libsasl2-modules-gssapi-mit \
    libsasl2-modules-ldap \
    libsasl2-modules-otp \
    libsasl2-modules-sql \
    openssl \
    slapd \
    && apt-get remove -y --purge --auto-remove curl ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/ldap/slapd.d/*

COPY configs/slapd.conf /etc/ldap/slapd.conf
COPY configs/ad.schema /etc/ldap/schema/ad.schema

EXPOSE 389

ENTRYPOINT ["slapd", "-d", "4"]
