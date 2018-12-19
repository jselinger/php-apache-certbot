FROM webdevops/php-apache

ENV DOMAINS="domain.tld"
ENV EMAIL="admin@$DOMAINS"
ENV SHFILE="/opt/docker/etc/httpd/file.sh"
ENV PAGESPEED="false"

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install sendmail -y
RUN apt-get install ssmtp -y
RUN add-apt-repository ppa:certbot/certbot -y
RUN apt-get update
RUN apt install python-certbot-apache -y
RUN echo "certbot --apache --non-interactive --agree-tos --email $EMAIL --domains $DOMAINS certonly"

RUN if [ "$PAGESPEED" = "true" ] ; then
RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
RUN dpkg -i mod-pagespeed-*.deb
RUN sudo apt-get -f install
RUN rm -rf mod-pagespeed-*.deb ;
RUN else echo cache disabled ;
RUN fi

RUN echo $(head -1 /etc/hosts | cut -f1) $DOMAINS >> /etc/hosts\
RUN apt-get update
RUN apt-get upgrade -y
RUN service apache2 restart
RUN if [ ! -f "$SHFILE" ] ; then echo file not found ; else chmod +x $SHFILE && $SHFILE ; fi
