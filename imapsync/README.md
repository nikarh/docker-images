# nikarh/fileserver-imapsync

This is `alpine` with `imapnotify` and `mbsync`, configured specifically to backup emails from gmail using OAUTH2.

## Usage

`imap.env`
```yaml
USERNAME=myaccount@gmail.com
CLIENT_ID="oauth client id"
CLIENT_SECRET="oauth secret"
REFRESH_TOKEN="oauth refresh token"
```

`docker-compose.yaml`
```yaml
version: '3.8'
secrets:
  IMAP_AUTH:
    file: imap.env
services:
  imapsync:
    image: nikarh/fileserver-imapsync
    user: 1000:1000
    environment:
      # Mail will be synced to /home/${USERNAME}/mail
      # This is useful if the volume is also used with dovecot and multiple user mailboxes
      USERNAME: test
    volumes:
      - mail-data:/home
    secrets:
      - IMAP_AUTH

```
