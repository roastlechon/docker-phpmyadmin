FROM phusion/passenger-full:0.9.11

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y build-essential python-software-properties unzip wget
RUN apt-get install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt php5-intl php5-imap php5-tidy

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

RUN rm -f /etc/service/nginx/down

RUN rm -rf /etc/nginx/sites-enabled/default

ADD build/webapp.conf /etc/nginx/sites-enabled/webapp.conf

RUN wget -P /tmp https://files.phpmyadmin.net/phpMyAdmin/4.5.0.2/phpMyAdmin-4.5.0.2-all-languages.zip
RUN unzip /tmp/phpMyAdmin-4.5.0.2-all-languages.zip -d /tmp/
RUN mv /tmp/phpMyAdmin-4.5.0.2-all-languages/config.sample.inc.php /tmp/phpMyAdmin-4.5.0.2-all-languages/config.inc.php

RUN mkdir -p /home/app/webapp/public
RUN mv /tmp/phpMyAdmin-4.5.0.2-all-languages/* /home/app/webapp/public/

RUN mkdir           /etc/service/phpfpm
ADD runit/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

ADD my_init.d/99_phpmyadmin_setup.sh /etc/my_init.d/99_phpmyadmin_setup.sh
RUN chmod +x /etc/my_init.d/99_phpmyadmin_setup.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
