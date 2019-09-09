FROM sameersbn/squid:3.3.8-1
MAINTAINER lucas4paz@gmail.com

RUN apt-get update \
# && apt-get install -y squid3 \
 && apt-get install -y squidguard \
 && apt-get install -y krb5-kdc krb5-config libpam-krb5 krb5-user \
 && apt-get install -y apache2 

RUN echo 'AddType application/x-ns-proxy-autoconfig .dat' >> /etc/apache2/httpd.conf
#ADD entrypoint.sh /sbin/entrypoint.sh
#RUN chmod a+x /sbin/entrypoint.sh
ADD wpad.dat /var/www/html/wpad.dat
# for backward compatibility add it also with typo ;)
ADD wpad.dat /var/www/html/wpat.dat
ADD block.html /var/www/html/block.html

RUN echo "redirect_program /usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf" >> /etc/squid3/squid.conf

RUN rm /etc/squidguard/squidGuard.conf
ADD sample-config-blacklist /sample-config-blacklist
ADD sample-config-simple /sample-config-simple
RUN mkdir /custom-config

ADD startSquidGuard /startSquidGuard
RUN chmod a+x /startSquidGuard
#RUN systemctl start apache2
EXPOSE 3128 

VOLUME ["/var/log/squid3"]
VOLUME ["/custom-config"]

CMD ["/startSquidGuard"]
