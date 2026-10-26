# Flutter 3.47.7 build image for machines without a local Flutter SDK (ADR-0002).
# Build: docker build -t plant-flutter:3.47.7 -f tools/flutter.Dockerfile tools
FROM ghcr.io/cirruslabs/flutter:3.44.0
USER root
RUN rm -rf $FLUTTER_HOME && curl -fsSL -o /tmp/f.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.7-stable.tar.xz  && echo "af7455f540df951184c7953fbe3cf884766e7541dacf8571f9f582db03dd6230  /tmp/f.tar.xz" | sha256sum -c -  && mkdir -p $(dirname $FLUTTER_HOME) && tar -xJf /tmp/f.tar.xz -C /tmp && mv /tmp/flutter $FLUTTER_HOME && rm /tmp/f.tar.xz  && git config --global --add safe.directory '*' && flutter config --no-analytics && flutter --disable-analytics && dart --disable-analytics && flutter precache --android && flutter --version
