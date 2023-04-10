# nikarh/fileserver-sftpd-backup

This image can be used to make daily backups of your data.
You can mount something to a `/volumes` folder. Each folder inside will be treated as a candidate for a backup, e.g. if you have `/volumes/A`, `/volumes/B` and `/volumes/C`, then `A`, `B` and `C` will be considered as separate entities.
Each candidate for a backup will be tar-xzipped, a timestamp will be appended to a filename, and a file will be copied to SFTP server. This tool will try to keep only the latest N number of backups per candidate.

## Usage

```yaml
version: '3.8'
secrets:
  SSH_KEY:
    file: my_ssh_key
services:
  samba:
    image: nikarh/dotfiles-sftpd-backup
    environment:
      MAXIMUM_BACKUP_NUMBER: 3 # Keep only 3 latest archives per volume
      SFTP_SERVER: files
      SFTP_USER: backup
      SFTP_ROOT: /data/server
    volumes:
      # Volumes to backup
      - volume1:/volumes/volume1:ro
      - volume2:/volumes/volume2:ro
    secrets:
      - SSH_KEY
```
