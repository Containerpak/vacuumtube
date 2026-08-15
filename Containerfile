FROM ubuntu:26.04 AS source

ADD --checksum=sha256:29635ee91ab67e61073fa86fa45ebb6a5ce9507feb73a9197c26cbe59621d37f https://github.com/shy1132/VacuumTube/releases/download/v1.8.2/VacuumTube-x86_64.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/vacuumtube"

COPY --from=source /stage/ /opt/vacuumtube/
COPY vacuumtube /usr/bin/vacuumtube
COPY vacuumtube.desktop /usr/share/applications/vacuumtube.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/vacuumtube.png

RUN chmod 0755 /usr/bin/vacuumtube && cpak-clean-junk
