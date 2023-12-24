FROM alpine

RUN apk add --no-cache python3 py3-pip

ADD https://github.com/NicKoehler/mediafire_bulk_downloader/archive/refs/heads/master.zip /tmp/
RUN unzip /tmp/master.zip -d / \
  && mv /mediafire_bulk_downloader-master /downloader \
  && rm /tmp/master.zip \
  && cd /downloader \
  && python -m venv /downloader/.venv \
  && . /downloader/.venv/bin/activate \
  && python -m pip install -r requirements.txt

ENTRYPOINT ["python", "/downloader/mediafire.py"]
