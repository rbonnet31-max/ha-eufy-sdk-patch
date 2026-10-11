# Add-on officiel eufy-sdk bridge 0.5.0 (image publiée) + correctif du cache de clés level-2 (patch.sh)
ARG BUILD_ARCH=amd64
FROM ghcr.io/mega-yfue/${BUILD_ARCH}-addon-eufy-sdk-bridge:0.5.0
COPY patch.sh /patch.sh
RUN sh /patch.sh && rm /patch.sh
