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

RUN \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dbus \
    ca-certificates \
    curl \
    unzip \
    jq \
    libnss3 \
    libasound2 \
    libx11-6 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libx11-xcb1 \
    libxkbcommon0 \
    libgtk-3-0 && \
  echo "**** install Libation ****" && \
  mkdir -p /opt/libation && \
  if [ "${LIBATION_RELEASE}" = "latest" ]; then \
    LIBATION_TAG=$(curl -sX GET "https://api.github.com/repos/rmcrackan/Libation/releases/latest" | jq -r .tag_name); \
  else \
    LIBATION_TAG="${LIBATION_RELEASE}"; \
  fi && \
  echo "Using Libation release tag: ${LIBATION_TAG}" && \
  LIBATION_URL="https://github.com/rmcrackan/Libation/releases/download/${LIBATION_TAG}/Libation-${LIBATION_TAG}-linux-x64.zip" && \
  curl -L -o /tmp/libation.zip "${LIBATION_URL}" && \
  unzip /tmp/libation.zip -d /opt/libation && \
  rm /tmp/libation.zip && \
  chmod +x /opt/libation/Libation || true && \
  dbus-uuidgen > /etc/machine-id && \
  printf "docker-libation version: %s\nBuild-date: %s" "${VERSION}" "${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY root/ /
