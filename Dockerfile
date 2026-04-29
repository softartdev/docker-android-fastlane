FROM openjdk:17.0.2-jdk-slim-bullseye

ARG TARGETARCH

LABEL maintainer="softartdev <artik222012@gmail.com>"

ENV JAVA_HOME=/usr/local/openjdk-17
ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
    ANDROID_API_LEVEL=android-36.1 \
    ANDROID_BUILD_TOOLS_VERSION=36.1.0 \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    ANDROID_SDK_ROOT=/usr/local/android-sdk-linux \
    ANDROID_VERSION=36.1
ENV PATH=${JAVA_HOME}/bin:${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

RUN if [ "$TARGETARCH" = "arm64" ]; then dpkg --add-architecture amd64; fi && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl git ruby-dev ruby-full unzip && \
    if [ "$TARGETARCH" = "arm64" ]; then apt-get install --no-install-recommends -y libc6:amd64 libgcc-s1:amd64; fi && \
    mkdir -p "$ANDROID_HOME/cmdline-tools" /root/.android && \
    printf '%s\n' \
    'export JAVA_HOME="${JAVA_HOME:-/usr/local/openjdk-17}"' \
    'export ANDROID_HOME="${ANDROID_HOME:-/usr/local/android-sdk-linux}"' \
    'export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"' \
    'export ANDROID_BUILD_TOOLS_VERSION="${ANDROID_BUILD_TOOLS_VERSION:-36.1.0}"' \
    'export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$PATH"' \
    > /etc/profile.d/android-sdk-java.sh && \
    cd "$ANDROID_HOME" && \
    curl -fsSL -o sdk.zip "$ANDROID_SDK_URL" && \
    unzip -q sdk.zip -d "$ANDROID_HOME/cmdline-tools" && \
    mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest" && \
    rm sdk.zip && \
# Download Android SDK
    yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
    sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" && \
# Install Fastlane
    gem install rake fastlane bundler --no-document && \
# Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
