# WeasyPrint server

## But

Convertir des documents html en pdf.

## Production

1. Télécharger le paquet `.deb` depuis la page Releases.
2. Installer le paquet :

    ```shell
    dpkg -i tmp/weasyprint_server_2026-01-15-14-18+c744464_amd64.deb
    ```
3. Lancer le serveur :

    ```shell
    BASE_URL=http://127.0.0.1:4000 UWSGI_HTTP_SOCKET=0.0.0.0:8000 UWSGI_STATS=0.0.0.0:9191 UWSGI_PROCESSES=4 UWSGI_ENABLE_THREADS=true UWSGI_MODULE=wsgi:app UWSGI_CHDIR=/opt/weasyprint/app /opt/weasyprint/app/.venv/bin/uwsgi
    ```

## Développement
### installation

On utilise [uv](https://github.com/astral-sh/uv) pour gérer python et ces dépendances.

On copy les variables d'env

```bash
cp env.example .env
```
---
Pour macosx il faut ajouter ces 2 étapes :

1- installer weasyprint avec homebrew 
```bash
brew install weasyprint
```

2- éxécuter cette ligne de commande
```bash
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH
```

### lancement de l'application

```bash
uv run flask run --debug

# or any process manager reading Procfile.dev
overmind start
```

### tests

```bash
uv run python -m unittest
```

### linters

```bash
uv run ruff format --check && uv run ruff check
```

## Packaging

- Builder un paquet .deb: `cd package_scripts && build.sh`
- Lancer le serveur dans un conteneur Docker : `cd package_scripts && run.sh`
- Les deux d'un coup: `cd package.sh && main.sh`
