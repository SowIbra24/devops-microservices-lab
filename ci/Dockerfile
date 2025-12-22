FROM alpine:3.19

RUN apk add --no-cache bash curl grep sed

WORKDIR /ci
COPY . /ci

ENTRYPOINT ["bash", "run.sh"]
