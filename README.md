# RethinkDB for fly.io

RethinkDB hosted on fly.io

## Setup

Start a new fly project:

```bash
fly launch --copy-config --no-deploy
```

Set the rethinkdb password:

```bash
fly secrets set RETHINKDB_PASSWORD=your_secret_password
```

A good secret can be generated with:

```bash
openssl rand -base64 30 | tr -d /=+ | cut -c -30
```

Or

```bash
pwgen -s 30
```

## Deploy

Deploy the project:

```bash
fly deploy
```

For production, you want to use a minimum of 3 database servers:

```bash
fly scale count app=3
```

## Access admin

To access the admin panel, you can use fly proxy:

```bash
fly proxy 8080:8080
```

## TODO

- Add health checks
