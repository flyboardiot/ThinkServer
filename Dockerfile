FROM ubuntu:20.04
MAINTAINER Flyrainning "http://www.fengpiao.net"

ENV DEBIAN_FRONTEND noninteractive
ENV ACCEPT_EULA Y

RUN apt-get update -y \
  && apt-get install -y \
    curl \
    gnupg2 \
    wget


RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list


RUN apt-get update -y \
  && apt-get install -y \
    iputils-ping \
    net-tools \
    msodbcsql17 \
    unixodbc-dev \
    openssl \
    nginx \
    php-fpm \
    php-cli \
    php-imagick \
    php-json \
    php-services-json \
    php-mail \
    php-mbstring \
    php-memcached \
    php-mongodb \
    php-redis \
    php-xml \
    php-zip \
    php-ssh2 \
    php-curl \
    php-gd \
    php-mysql \
    php-odbc \
    php-sqlite3 \
    php-xmlrpc \
    php-sybase \
    php-amqp \
    php-geos \
    php-http-request \
    php-log \
    php-markdown \
    php-net-socket \
    php-pgsql \
    php-yaml \
    php-pear \
    php-dev \
    librdkafka-dev \
    libmosquitto-dev \
  && apt-get autoclean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

ADD etc /etc
ADD app /app
ADD bin /bin


RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod sqlsrv pdo_sqlsrv

RUN pecl install rdkafka
RUN echo extension=rdkafka.so > /etc/php/7.4/mods-available/rdkafka.ini
RUN phpenmod rdkafka

RUN pecl install Mosquitto-alpha
RUN printf "; priority=40\nextension=mosquitto.so\n" > /etc/php/7.4/mods-available/mosquitto.ini
RUN phpenmod mosquitto

RUN pecl install swoole
RUN printf "; priority=40\nextension=swoole.so\n" > /etc/php/7.4/mods-available/swoole.ini
RUN phpenmod swoole

#RUN sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf

WORKDIR /app
RUN chmod a+x /bin/start.sh /bin/install.sh
RUN /bin/install.sh

ENV VERSION 1
ENV PATH "/app:$PATH"

EXPOSE 80
ENTRYPOINT ["/bin/start.sh"]
