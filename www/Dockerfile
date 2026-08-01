FROM nginx:1.27-alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/aula/

# Smoke-check required SEO artifacts exist under /aula/
RUN test -f /usr/share/nginx/html/aula/index.html \
 && test -f /usr/share/nginx/html/aula/privacy.html \
 && test -f /usr/share/nginx/html/aula/robots.txt \
 && test -f /usr/share/nginx/html/aula/sitemap.xml \
 && test -f /usr/share/nginx/html/aula/assets/css/site.css

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/aula/ || exit 1
