FROM alpine

RUN apk add --no-cache python3 py3-pip git

WORKDIR /downloader

RUN python -m venv /downloader/.venv \
  && . /downloader/.venv/bin/activate \
  && pip3 install git+https://github.com/NicKoehler/mediafire_bulk_downloader

ENTRYPOINT ["python", ".venv/lib/python3.11/site-packages/mediafire.py"]
