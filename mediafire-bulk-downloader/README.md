# nikarh/mediafire-bulk-downloader

[Mediafire bulk downloader](https://github.com/NicKoehler/mediafire_bulk_downloader) wrapped in a docker image.

## Usage

```
  docker run --rm
    -v folder:/out \ 
    nikarh/mediafire-bulk-downloader \
    <MEDIAFIRE_URL> -t <THREADS> -o /out
```
