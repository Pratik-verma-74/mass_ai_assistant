# Use Gitpod's full workspace image as base
FROM gitpod/workspace-full

USER root
RUN apt-get update \
 && apt-get install -y curl unzip xz-utils git libglu1-mesa \
 && apt-get clean

# Download & extract Flutter SDK (linux stable)
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.8-stable.tar.xz -o /tmp/flutter.tar.xz \
 && tar -xJf /tmp/flutter.tar.xz -C /home/gitpod \
 && rm /tmp/flutter.tar.xz \
 && chown -R gitpod:gitpod /home/gitpod/flutter

# Add Flutter and Dart to PATH
ENV PATH="/home/gitpod/flutter/bin:/home/gitpod/flutter/bin/cache/dart-sdk/bin:${PATH}"

USER gitpod
