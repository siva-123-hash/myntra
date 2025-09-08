
FROM nginx:alpine


RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html


HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost/ || exit 1

EXPOSE 80

