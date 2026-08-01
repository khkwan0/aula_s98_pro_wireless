# AULA S98 Pro — marketing site (`www/`)

Static, SEO-oriented marketing site for the AULA S98 Pro Wireless Companion, plus a **fully self-hosted** CI/CD path that builds and deploys **on this host** when GitHub pushes to `main`. No GitHub Actions runners, no Vercel/Netlify/Cloudflare Pages.

## What’s here

| Path | Purpose |
|------|---------|
| `public/` | Site root (HTML, CSS, JS, screenshots, `robots.txt`, `sitemap.xml`) |
| `nginx/` | Container nginx config + host reverse-proxy (site + webhook path) |
| `Dockerfile` / `docker-compose.yml` | Build & serve with nginx in Docker |
| `ci/` | Lint → test → deploy pipeline + GitHub webhook listener |
| `hooks/post-receive` | Optional bare-repo hook (legacy alternative to GitHub webhook) |

Default public URL: `https://nitroxstudios.com/aula/`

## Local preview

```bash
cd www
docker compose up -d --build
# open http://127.0.0.1:8098/aula/
```

Or run stages individually:

```bash
bash ci/lint.sh
bash ci/test.sh      # needs Docker
bash ci/deploy.sh
# or
bash ci/pipeline.sh all
```

## Self-hosted CI/CD (GitHub webhook → local build)

On push to `main`, GitHub POSTs to this host. A local listener verifies the HMAC secret, pulls `origin/main`, then runs `ci/pipeline.sh` (Docker image build + compose roll) on **this machine**.

### One-time setup on the deploy host

```bash
# 1) First build + start container on :8098
bash www/ci/pipeline.sh all

# 2) Webhook listener (user systemd) + secret file outside the repo
bash www/ci/install-webhook.sh

# 3) Enable host nginx vhost (existing nginx) + Let's Encrypt + linger
sudo bash www/ci/setup-host-nginx.sh
sudo loginctl enable-linger "$USER"
```

Then in GitHub → **Settings → Webhooks → Add webhook**:

| Field | Value |
|-------|--------|
| Payload URL | `https://nitroxstudios.com/hooks/github/aula-www` |
| Content type | `application/json` |
| Secret | from `~/.config/aula-s98-www/webhook.env` (`grep WEBHOOK_SECRET …`) |
| Events | Just the **push** event |

After that, every `git push origin main` triggers a local rebuild.

```bash
# Manual deploy without waiting for a webhook
bash www/ci/pipeline.sh all

# Logs
journalctl --user -u aula-s98-www-webhook -f
tail -f ~/.local/share/aula-s98-www/deploy.log
```

Override the published port with `WWW_PORT=8080 bash ci/deploy.sh` if needed.

### Optional: bare git remote (legacy)

```bash
bash www/ci/install-remote.sh
git remote add mala ken@<host>:/home/ken/git/aula_s98_pro_wireless.git
git push mala main
```

## Download link

The site points at the published GitHub Release binary:

`https://github.com/khkwan0/aula_s98_pro_wireless/releases/download/v1.0.0/AULA.S98.Pro.dmg`
