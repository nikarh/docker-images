# nikarh/fileserver-samba

An `alpine` image with `smbd` and `nmbd`. Also includes some other tools such as `jq` and `curl`.

This image scans a mounted volume to `/home`, for each folder inside it creates a new user anf group (all users share the same UID and GID).
Then it creates a share per user and starts `smbd` and `nmbd`.

## Usage

```yaml
version: '3.8'
services:
  samba:
    image: nikarh/dotfiles-samba
    environment:
      UID: 1000
      GID: 1000
    ports:
      - 137:137/udp # nmbd
      - 138:138/udp # nmbd
      - 139:139 # smb over netbios
      - 445:445 # smb over tcp
    volumes:
      # Data directory. Should contain a folder per smb user.
      - /{data}:/home
```

## Considerations

I'm not a huge fan of SMB, but this is the most widely supported protocol for file sharing. With it files from my server are easily accessible from Linux, Mac, Windows, Android, and Android TV devices.

Even though samba can use either NTLM or kerberos for authentication, for the widest target client device you would almost exclusively use NTLM. And NTLM is pure nonsense. Under no circumstances SMB service should be exposed outside of DMZ/NAT/firewall.

Considering that this service would always be running behind a firewall, security is not a huge deal in my case, so in default configuration

- Encryption is disabled for performance reasons
- Users are automatically generated with passwords equal to usernames

This behavior can be overridden by mounting custom `/etc/samba/smb-base.conf` and `/scripts/create-users.sh`.

Also this image creates a single rw share for each user to their home directory. If some other layout desired, mount a shell with custom logic script to `/scripts/create-shares.sh`.
