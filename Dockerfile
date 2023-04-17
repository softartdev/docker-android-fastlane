FROM ubuntu

LABEL softartdev <artik222012@gmail.com>

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ENV ANDROID_API_LEVEL android-30
ENV ANDROID_BUILD_TOOLS_VERSION 30.0.3
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_VERSION 30
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl gnupg unzip
RUN curl -s https://apt.corretto.aws/corretto.key | apt-key add -
RUN echo 'deb https://apt.corretto.aws stable main' | tee /etc/apt/sources.list.d/corretto.list
RUN apt-get update
RUN apt-get install -y java-17-amazon-corretto-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto/
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto/' >> /home/.bashrc

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ENV ANDROID_API_LEVEL android-33
ENV ANDROID_BUILD_TOOLS_VERSION 33.0.2
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_VERSION 30
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
# Download Android SDK
yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
sdkmanager --update --sdk_root=$ANDROID_HOME && \
sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" \
    "extras;android;m2repository" \
    "extras;google;m2repository" && \
# Install Fastlane
apt-get update && \
apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby-full && \
gem install rake && \
gem install fastlane && \
gem install bundler && \
# Clean up
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
apt-get autoremove -y && \
apt-get clean
