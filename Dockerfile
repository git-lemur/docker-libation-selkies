# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

ARG BUILD_DATE
ARG VERSION
ARG LIBATION_RELEASE

LABEL build_version="docker-libation version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="yourname"

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/config" \
  TITLE="Libation" \
  QTWEBENGINE_DISABLE_SANDBOX="1" \
  LIBATION_RELEASE="${LIBATION_RELEASE:-latest}"

ARG TARGETARCH

RUN \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dbus \
    ca-certificates \
    curl \
    jq && \
  echo "**** install Libation ****" && \
  if [ "${LIBATION_RELEASE}" = "latest" ]; then \
    LIBATION_TAG=$(curl -sX GET "https://api.github.com/repos/rmcrackan/Libation/releases/latest" | jq -r .tag_name); \
  else \
    LIBATION_TAG="${LIBATION_RELEASE}"; \
  fi && \
  echo "Using Libation release tag: ${LIBATION_TAG}" && \
  LIBATION_URL=$(curl -sX GET "https://api.github.com/repos/rmcrackan/Libation/releases/tags/${LIBATION_TAG}" | jq -r --arg arch "$TARGETARCH" '.assets[] | select(.name | endswith("linux-chardonnay-" + $arch + ".deb")) | .browser_download_url' | head -n 1) && \
  echo "Downloading Libation for ${TARGETARCH} from: ${LIBATION_URL}" && \
  curl -L -o /tmp/libation.deb "${LIBATION_URL}" && \
  apt-get install -y /tmp/libation.deb && \
  rm /tmp/libation.deb && \
  dbus-uuidgen > /etc/machine-id && \
  printf "docker-libation version: %s\nBuild-date: %s" "${VERSION}" "${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY root/ /

RUN \
  apt-get update && \
  apt-get install -y dos2unix && \
  dos2unix /defaults/autostart /defaults/autostart_wayland && \
  chmod +x /defaults/autostart /defaults/autostart_wayland && \
  apt-get clean
