FROM alpine:latest

WORKDIR /app

RUN apk update
RUN apk add openrc nginx php-fpm php-mysqli mysql mysql-client nano --no-cache

RUN sed -i 's/return 404;/index index\.php index\.html;/g' /etc/nginx/http.d/default.conf
RUN sed -i 's/server {/server {\n\troot \/var\/www\/localhost\/htdocs\/wordpress;/g' /etc/nginx/http.d/default.conf 
RUN sed -i 's/listen \[\:\:\]\:80 default_server;/listen \[\:\:\]\:80 default_server;\n\tlocation ~ \\\.php\$ {\n\t\tfastcgi_pass 127\.0\.0\.1:9000;\n\t\tfastcgi_index index\.php;\n\t\tinclude fastcgi\.conf;\n\t}/' /etc/nginx/http.d/default.conf

COPY base.sql /app/base.sql
COPY entrypoint.sh /run/entrypoint.sh
RUN chmod +x /run/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/run/entrypoint.sh"]

