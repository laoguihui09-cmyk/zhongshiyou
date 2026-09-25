FROM nginx:1.27-alpine

ENV ANDROID_DOWNLOAD_URL=""
ENV IOS_DOWNLOAD_URL=""

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1

CMD ["/bin/sh", "-c", "test -n \"$ANDROID_DOWNLOAD_URL\" && test -n \"$IOS_DOWNLOAD_URL\" && envsubst '$ANDROID_DOWNLOAD_URL $IOS_DOWNLOAD_URL' < /usr/share/nginx/html/config.template.js > /usr/share/nginx/html/config.js && exec nginx -g 'daemon off;'"]
