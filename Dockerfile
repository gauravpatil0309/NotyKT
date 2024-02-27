# Base image with Android SDK and necessary dependencies
FROM openjdk:11-jdk

# Set environment variables
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV ANDROID_SDK_ROOT=/sdk

# Install Android SDK
RUN yum update -y && \
    yum install -y wget tar unzip glibc.i686 zlib.i686 lib32stdc++6 lib32z1 && \
    yum clean all && \
    wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \ 
    unzip -d android-sdk-linux android-sdk.zip && \
    echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null && \
    echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" >/dev/null && \
    echo y | android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null && \
    rm -rf android-sdk.zip

# Set PATH to include Android SDK tools
ENV PATH=${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools:${PATH}

# Copy the Android project files to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Build the Android application
RUN ./gradlew clean assembleDebug

