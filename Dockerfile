FROM nginx:1.23.3
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html
COPY build .

# These steps allow runtime vars to be injected
COPY env.sh /docker-entrypoint.d
COPY .env.template /docker-entrypoint.d
RUN chmod +x /docker-entrypoint.d/env.sh
