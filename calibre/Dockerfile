FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/app/data/config/" \
  TITLE="Calibre" \
  QTWEBENGINE_DISABLE_SANDBOX="1"

RUN mkdir -p /app/code/calibre
WORKDIR /app/code

RUN echo "**** install runtime packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    libnss3 \
    libopengl0 \
    libqpdf28 \
    libxkbcommon-x11-0 \
    libxcb-cursor0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev \
    qt6-base-dev \
    poppler-utils \
    python3 \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils && \
    apt-get install -y \
    speech-dispatcher;

RUN if [ -z ${CALIBRE_RELEASE+x} ]; then \
    CALIBRE_RELEASE=$(curl -sX GET "https://api.github.com/repos/kovidgoyal/calibre/releases/latest" \
    | jq -r .tag_name); \
    fi && \
    CALIBRE_VERSION="$(echo ${CALIBRE_RELEASE} | cut -c2-)" && \
    CALIBRE_URL="https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz" && \
    curl -o \
    /tmp/calibre-tarball.txz -L \
    "$CALIBRE_URL" && \
    tar xvf /tmp/calibre-tarball.txz -C \
    /app/code/calibre && \
    /app/code/calibre/calibre_postinstall && \
    dbus-uuidgen > /etc/machine-id;

RUN echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN chown -R cloudron:cloudron /app/code/calibre

COPY start.sh /app/code/

CMD [ "/app/code/start.sh" ]
