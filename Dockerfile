# Base image with Android SDK and necessary dependencies
FROM openjdk:11-jdk

# Set environment variables
ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV ANDROID_SDK_ROOT=/sdk
ENV GRADLE_VERSION=7.0.2

# Install System Dependencies
RUN apt-get --quiet update --yes && \
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

# Install Android SDK    
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \ 
    unzip -d android-sdk-linux android-sdk.zip

# Install Gradle
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    unzip gradle.zip
   

# Set PATH to include Android SDK tools
ENV PATH=${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools:${PATH}
ENV PATH=/gradle-${GRADLE_VERSION}/bin:$PATH

# Copy the Android project files to the container
COPY noty-android/ /app

# Set the working directory
WORKDIR /app

# Build the Android application
RUN ./gradlew clean assembleDebug

