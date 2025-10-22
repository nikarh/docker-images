# Based on nberktumer/ha-bambu-lab-p1-spaghetti-detection (GPLv3)
# Original source: https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection/blob/d1937cc09b1acf789c61b0906d24781e7db352d0/addon/Dockerfile.standalone.base
# Modifications by nikarh


# Stage 1: Clone repository and apply patches
FROM alpine:latest AS patcher

RUN apk add --no-cache git

WORKDIR /build
RUN git clone https://github.com/nberktumer/ha-bambu-lab-p1-spaghetti-detection.git .

COPY bambu-lab.patch /build/
RUN git apply bambu-lab.patch

# Stage 2: Build the final image
FROM thespaghettidetective/ml_api_base:1.4
WORKDIR /app
EXPOSE 3333

COPY --from=patcher /build/addon/rootfs/app /app
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN echo 'Downloading the latest failure detection AI model in Darknet format...'
RUN wget -O model/model-weights.darknet $(cat model/model-weights.darknet.url | tr -d '\r')
RUN echo 'Downloading the latest failure detection AI model in ONNX format...'
RUN wget -O model/model-weights.onnx $(cat model/model-weights.onnx.url | tr -d '\r')

ENV FLASK_APP=server.py

CMD ["gunicorn", "--bind", "0.0.0.0:3333", "--workers", "1", "wsgi"]

