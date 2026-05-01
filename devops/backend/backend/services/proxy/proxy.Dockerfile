FROM nginx:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY ./openssl/ /etc/openssl/