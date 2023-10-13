#docker run  -v /Users/damien/Documents/Blog/OC/ASR/734/P8\ -\ Supervisez\ le\ SI\ d\'une\ entreprise:/app -d --name wordpress -ti alpine
FROM alpine:latest

WORKDIR /app

ENV PORT=80

RUN apk update
RUN apk add openrc nginx php-fpm php-mysqli mysql mysql-client --no-cache

RUN sed -i 's/return 404;/index index\.php index\.html;/g' /etc/nginx/http.d/default.conf
RUN sed -i 's/server {/server {\n\troot \/var\/www\/localhost\/htdocs\/wordpress;/g' /etc/nginx/http.d/default.conf 
RUN sed -i 's/listen \[\:\:\]\:80 default_server;/listen \[\:\:\]\:80 default_server;\n\tlocation ~ \\\.php\$ {\n\t\tfastcgi_pass 127\.0\.0\.1:9000;\n\t\tfastcgi_index index\.php;\n\t\tinclude fastcgi\.conf;\n\t}/' /etc/nginx/http.d/default.conf

COPY base.sql /app/base.sql
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/app/entrypoint.sh"]

