FROM debian:jessie

# install php 7.0
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install wget && \
    echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && \
    wget -qO - https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y install php7.0-fpm php7.0-cli php7.0-gd php7.0-imap \
                       php7.0-intl php7.0-json php7.0-ldap php7.0-mcrypt \
                       php7.0-mysql php7.0-sqlite3 php7.0-curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /run/php && \
    chown www-data:www-data /run/php

# remove warning "PHP Warning:  Module 'mcrypt' already loaded in Unknown on line 0"
RUN sed 's/extension=mcrypt.so/;extension=mcrypt.so/g' -i /etc/php/mods-available/mcrypt.ini

# increase performance
RUN sed 's/pm.max_children = 5/;pm.max_children = 50/g' -i /etc/php/7.0/fpm/pool.d/www.conf
RUN sed 's/pm.start_servers = 2/;pm.start_servers = 10/g' -i /etc/php/7.0/fpm/pool.d/www.conf
RUN sed 's/pm.max_spare_servers = 3/;pm.max_spare_servers = 15/g' -i /etc/php/7.0/fpm/pool.d/www.conf

VOLUME ["/run/php", "/srv/www"]

# start fpm
CMD ["php-fpm7.0", "--nodaemonize", "--fpm-config", "/etc/php/7.0/fpm/php-fpm.conf"]