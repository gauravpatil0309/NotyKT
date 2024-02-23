# Use a base image with Android SDK installed
FROM androidsdk/android-30

# Set the working directory
WORKDIR /app

# Copy the project files to the container
COPY . .

# Build the Android application
RUN ./gradlew clean assembleDebug
