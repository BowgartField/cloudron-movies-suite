FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update -y && \
    apt install -y curl sqlite3 dpkg

RUN mkdir -p /app/code/sonarr
WORKDIR /app/code

RUN wget --content-disposition "https://services.sonarr.tv/v1/download/master/latest?version=4&os=linux&arch=x64" -O Sonarr.tar.gz && \
    tar -xvzf Sonarr.tar.gz -C /app/code/sonarr

COPY start.sh /app/code/

CMD [ "/app/code/start.sh" ]