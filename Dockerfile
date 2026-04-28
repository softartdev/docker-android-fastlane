FROM openjdk:17.0.2-jdk-slim-bullseye

LABEL maintainer="softartdev <artik222012@gmail.com>"

ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
    ANDROID_API_LEVEL=android-35 \
    ANDROID_BUILD_TOOLS_VERSION=35.0.0 \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    ANDROID_SDK_ROOT=/usr/local/android-sdk-linux \
    ANDROID_VERSION=35
ENV PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl git ruby-dev ruby-full unzip && \
    mkdir -p "$ANDROID_HOME/cmdline-tools" /root/.android && \
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
