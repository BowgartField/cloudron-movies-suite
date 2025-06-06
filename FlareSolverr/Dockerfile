# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

# Build dummy packages to skip installing them and their dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends equivs \
    && equivs-control libgl1-mesa-dri \
    && printf 'Section: misc\nPriority: optional\nStandards-Version: 3.9.2\nPackage: libgl1-mesa-dri\nVersion: 99.0.0\nDescription: Dummy package for libgl1-mesa-dri\n' >> libgl1-mesa-dri \
    && equivs-build libgl1-mesa-dri \
    && mv libgl1-mesa-dri_*.deb /libgl1-mesa-dri.deb \
    && equivs-control adwaita-icon-theme \
    && printf 'Section: misc\nPriority: optional\nStandards-Version: 3.9.2\nPackage: adwaita-icon-theme\nVersion: 99.0.0\nDescription: Dummy package for adwaita-icon-theme\n' >> adwaita-icon-theme \
    && equivs-build adwaita-icon-theme \
    && mv adwaita-icon-theme_*.deb /adwaita-icon-theme.deb

RUN git clone https://github.com/FlareSolverr/FlareSolverr.git /app/code/flaresolverr

# Install dependencies and create flaresolverr user
# You can test Chromium running this command inside the container:
#    xvfb-run -s "-screen 0 1600x1200x24" chromium --no-sandbox
# The error traces is like this: "*** stack smashing detected ***: terminated"
# To check the package versions available you can use this command:
#    apt-cache madison chromium
WORKDIR /app/code/flaresolverr
    # Install dummy packages
RUN dpkg -i /libgl1-mesa-dri.deb \
    && dpkg -i /adwaita-icon-theme.deb \
    # Install dependencies
    && apt-get update \
    && apt-get install -y --no-install-recommends chromium-driver xvfb dumb-init \
        procps curl vim xauth \
    # Remove temporary files and hardware decoding libraries
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /usr/lib/x86_64-linux-gnu/libmfxhw* \
    && rm -f /usr/lib/x86_64-linux-gnu/mfx/* \
    # Create flaresolverr user
    && useradd --home-dir /app/code --shell /bin/sh flaresolverr \
    && mv /usr/bin/chromedriver chromedriver \
    && chown -R cloudron:cloudron .

RUN sudo add-apt-repository ppa:saiarcot895/chromium-beta
RUN sudo apt install -y chromium-browser

RUN mkdir -p "/app/code/flaresolverr/.config"
RUN ln -s /app/data/config /app/code/flaresolverr/.config 
RUN ln -s /app/data/cache /root/.local

# Install Python dependencies

RUN pip install -r /app/data/flaresolverr/requirements.txt \
    && rm -rf /root/.cache

COPY start.sh /app/code
COPY config.conf /tmp/config.conf

ENV LANG=en_EN
ENV TZ=Europe/Paris
ENV LOG_LEVEL=debug

RUN mkdir -p "/app/data/flaresolverr/.config/chromium/Crash Reports/pending"

EXPOSE 8191
EXPOSE 8192

# dumb-init avoids zombie chromium processes
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/app/code/start.sh"]
