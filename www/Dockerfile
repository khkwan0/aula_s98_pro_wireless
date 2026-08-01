FROM nginx:1.27-alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

# Smoke-check required SEO artifacts exist in the image
RUN test -f /usr/share/nginx/html/index.html \
 && test -f /usr/share/nginx/html/privacy.html \
 && test -f /usr/share/nginx/html/robots.txt \
 && test -f /usr/share/nginx/html/sitemap.xml \
 && test -f /usr/share/nginx/html/assets/css/site.css

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
