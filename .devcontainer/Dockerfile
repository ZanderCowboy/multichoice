# Use an official Ubuntu runtime as a parent image
# FROM --platform=linux/amd64 ubuntu:latest
FROM --platform=linux/arm64 ubuntu:latest
# FROM --platform=linux ubuntu:latest
# FROM ubuntu:latest

# syntax=docker/dockerfile:1.2
# FROM --platform=linux/amd64,linux/arm64 ubuntu:latest

# Set the working directory to /app
WORKDIR /app

# Create a non-root user
RUN groupadd -r developer && useradd -r -g developer -m -d /home/developer developer

# Set the working directory and change ownership
RUN chown -R developer:developer /app

RUN mkdir -p /home/developer/.ssh
COPY .ssh /home/developer/.ssh
# ADD /Users/zanderk/.ssh/personal_github /home/developer/.ssh/personal_github
RUN chown -R developer:developer /home/developer/.ssh

# Install necessary dependencies
RUN apt-get update

RUN apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    gnupg \
    clang \
    cmake \
    ninja-build \
    pkg-config \ 
    libgtk-3-dev \
    libgconf-2-4 \
    zsh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Download and install Flutter
RUN git clone -b 3.16.9 https://github.com/flutter/flutter.git /usr/local/flutter

# Set the correct ownership for Flutter directory
RUN chown -R developer:developer /usr/local/flutter





# Install Chrome
# RUN mkdir -p /usr/share/keyrings/
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-archive-keyring.gpg
# RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list


# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'



# RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
# RUN gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub
# RUN echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
# RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'


# USER developer

RUN apt-get update 
# RUN apt-get install -y google-chrome-stable
RUN apt-get install -y chromium-browser


# RUN apt-get update \
#     && apt-get install -y google-chrome-stable

# Switch to the non-root user
USER developer

# Set Flutter bin directory to the user's PATH
ENV PATH="/usr/local/flutter/bin:${PATH}"



# Run flutter doctor to finish the installation and print any missing dependencies
RUN flutter doctor -v

# Set up the Flutter environment
RUN flutter config --no-analytics
RUN flutter precache

RUN chown -R developer:developer /usr/local/flutter/bin/cache

RUN flutter channel stable

# Switch to the non-root user
USER developer

# Expose ports for Flutter web development (optional)
EXPOSE 8080 5000

# CMD ["flutter", "run"]

# SETUP FOR ANDROID SDK 

# USER root
# Install packages
# RUN apt-get -qqy update && \
#     apt-get -qqy --no-install-recommends install software-properties-common && \
#     add-apt-repository ppa:openjdk-r/ppa && \
#     apt-get -qqy --no-install-recommends install \
#     openjdk-17-jdk \
#     curl \
#     zip \
#     unzip \
#     git \
#     locales \
#     && rm -rf /var/lib/apt/lists/*

# # Use unicode
# ENV LANG C.UTF-8

# ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-arm64/" \
#     PATH=$PATH:$JAVA_HOME/bin

# ENV ANDROID_SDK_ROOT="/usr/local/android-sdk"
# ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# ENV CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"

# Download Android SDK
# RUN mkdir "$ANDROID_SDK_ROOT" .android \
#     && mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools" \
#     && curl -o commandlinetools.zip $CMDLINE_TOOLS_URL \
#     && unzip commandlinetools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools" \
#     && mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest" \
#     && rm commandlinetools.zip

# # Accept all licenses
# RUN yes | sdkmanager --licenses

# Install Android build tools and platform tools
# ENV ANDROID_BUILD_TOOLS_VERSION=30.0.3

# RUN touch ~/.android/repositories.cfg

# RUN sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
#     "platform-tools" \
#     "emulator"

# RUN echo sdkmanager --list

# # Install Android build tools and platform tools
# ENV ANDROID_BUILD_TOOLS_VERSION=30.0.3
# ENV ANDROID_PLATFORM_VERSION="android-30"
# ENV ANDROID_EMULATOR_VERSION=latest

# RUN sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
#     "platform-tools" \
#     "emulator;${ANDROID_EMULATOR_VERSION}" \
#     "platforms;${ANDROID_PLATFORM_VERSION}" \
#     "system-images;${ANDROID_PLATFORM_VERSION};google_apis_playstore;arm64-v8a"

# # Create an Android Virtual Device (AVD)
# RUN echo "no" | avdmanager --verbose create avd \
#     --name test_avd \
#     --package "system-images;${ANDROID_PLATFORM_VERSION};google_apis_playstore;arm64-v8a" \
#     --tag google_apis_playstore \
#     --abi arm64-v8a \
#     --device "pixel" \
#     --sdcard 512M

# # Set environment variables for AVD
# ENV ANDROID_AVD_HOME="/root/.android/avd"
# ENV PATH=$PATH:$ANDROID_AVD_HOME/test_avd

# # Start emulator (you may adjust the parameters based on your needs)
# CMD emulator -avd test_avd -no-window -gpu swiftshader_indirect -no-audio -no-snapshot -no-boot-anim

RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"



# **** Post Create Command ****
# Add these lines at the end of your Dockerfile
USER root
COPY post_create_command.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/post_create_command.sh
# CMD ["/usr/local/bin/disable_telemetry.sh"]

RUN mkdir -p /workspaces/multichoice
RUN chown -R developer:developer /workspaces/multichoice



USER developer
