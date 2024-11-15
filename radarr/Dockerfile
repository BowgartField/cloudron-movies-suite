FROM --platform=amd64 cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update -y && \
    apt install -y curl sqlite3 dpkg

RUN mkdir -p /app/code/radarr
WORKDIR /app/code

RUN wget --content-disposition "http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64" && \
    tar -xvzf Radarr*.linux*.tar.gz -C /app/code/radarr

COPY start.sh /app/code/
RUN chown -R cloudron:cloudron /app/code/radarr

CMD [ "/app/code/start.sh" ]