FROM openjdk:8

LABEL softartdev <artik222012@gmail.com>

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH $PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

WORKDIR /opt

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
unzip -o -qq android-sdk.zip -d android-sdk && rm android-sdk.zip && \
# Download Android SDK
yes | sdkmanager "platform-tools" && \
yes | sdkmanager "platforms;android-28" && \
yes | sdkmanager "build-tools;28.0.3" && \
yes | sdkmanager "extras;android;m2repository" && \
yes | sdkmanager "extras;google;m2repository" && \
yes | sdkmanager --licenses && \
# Install Fastlane
apt-get update && apt-get install --no-install-recommends -y build-essential git ruby2.3-dev \
&& gem install fastlane \
&& gem install bundler \
# Clean up
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& apt-get autoremove -y && apt-get clean