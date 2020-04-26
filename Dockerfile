FROM gradle:5.6.4-jdk8

LABEL softartdev <artik222012@gmail.com>

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools:$PATH

WORKDIR /home

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
# Download Android SDK
yes | sdkmanager "platform-tools" && \
yes | sdkmanager "platforms;android-29" && \
yes | sdkmanager "build-tools;29.0.3" && \
yes | sdkmanager "extras;android;m2repository" && \
yes | sdkmanager "extras;google;m2repository" && \
yes | sdkmanager --licenses && \
# Install Fastlane
apt-get update && \
apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby-full && \
gem install fastlane && \
gem install bundler && \
# Clean up
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
apt-get autoremove -y && apt-get clean