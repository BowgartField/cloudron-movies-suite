# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update && apt-get install -y default-jre

RUN mkdir -p /app/code

RUN wget https://github.com/anthonyraymond/joal/releases/download/2.1.36/joal.tar.gz -O /app/code/joal.tar.gz && \
    tar -xzf /app/code/joal.tar.gz -C /app/code && \
    rm /app/code/joal.tar.gz;

COPY start.sh /app/code/
COPY config.conf /tmp

CMD [ "/app/code/start.sh" ]
