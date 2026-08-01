# AULA S98 Pro — marketing site (`www/`)

Static, SEO-oriented marketing site for the AULA S98 Pro Wireless Companion, plus a **fully self-hosted** CI/CD path that runs on your own machine (e.g. `mala`). No GitHub Actions, no Vercel/Netlify/Cloudflare Pages, no paid CI SaaS.

## What’s here

| Path | Purpose |
|------|---------|
| `public/` | Site root (HTML, CSS, JS, screenshots, `robots.txt`, `sitemap.xml`) |
| `nginx/` | Container nginx config + host reverse-proxy example |
| `Dockerfile` / `docker-compose.yml` | Build & serve with nginx in Docker |
| `ci/` | Lint → test → deploy pipeline scripts |
| `hooks/post-receive` | Git hook that runs the pipeline on push |

Default public URL in meta tags: `https://nitroxstudios.com/` (change if you use another hostname).

## Local preview

```bash
cd www
docker compose up -d --build
# open http://127.0.0.1:8098/
```

Or run stages individually:

```bash
bash ci/lint.sh
bash ci/test.sh      # needs Docker
bash ci/deploy.sh
# or
bash ci/pipeline.sh all
```

## Self-hosted CI/CD (one-time on the server)

On the deploy host (with Docker):

```bash
# from a full checkout of this repo
bash www/ci/install-remote.sh
```

That creates a bare repo at `/home/ken/git/aula_s98_pro_wireless.git` and installs a `post-receive` hook. Every push to `main`/`master`:

1. Checks out into `/home/ken/dev/aula_s98_pro_wireless`
2. Runs `www/ci/lint.sh` (SEO / structure)
3. Runs `www/ci/test.sh` (Docker build + HTTP smoke tests)
4. Runs `www/ci/deploy.sh` (compose rebuild + roll container on port `8098`)

From your laptop:

```bash
git remote add mala ken@<host>:/home/ken/git/aula_s98_pro_wireless.git
git push mala main
```

Manual deploy without git push:

```bash
bash www/ci/pipeline.sh all
```

### Optional public hostname

1. Point DNS for your host (e.g. `nitroxstudios.com`) at the server.
2. Install the example proxy: `www/nginx/host-proxy.conf.example` → `/etc/nginx/sites-available/…`
3. Enable the site and reload nginx. Add TLS with your existing cert tooling on the host.

Override the published port with `WWW_PORT=8080 bash ci/deploy.sh` if needed.

## Download link

The site points at the published GitHub Release binary:

`https://github.com/khkwan0/aula_s98_pro_wireless/releases/download/v1.0.0/AULA.S98.Pro.dmg`
