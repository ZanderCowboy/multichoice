# Experimental
FROM sapmachine:latest as android_stage

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV JAVA_HOME=/opt/jdk-17.0.9+9
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    android-sdk \
    sdkmanager

RUN apt install -y openjdk-17-jdk

# RUN java --version

# Add JAVA
# RUN mkdir /opt
# RUN mkdir ${JAVA_HOME}
# https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz
RUN wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_arm_linux_hotspot_17.0.9_9.tar.gz -O /tmp/openjdk.tar.gz && \
    tar xzfv /tmp/openjdk.tar.gz -C /opt/ && \
    rm /tmp/openjdk.tar.gz

# RUN export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) && echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment

# commandlinetools-linux-7302050_latest.zip
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/android-sdk.zip && \
    unzip /tmp/android-sdk.zip -d $ANDROID_HOME && \
    rm /tmp/android-sdk.zip
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

RUN yes | sdkmanager --licenses

RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# RUN sdkmanager --install "cmdline-tools;latest"

# platform-34-ext7_r02.zip
# RUN wget https://dl.google.com/android/repository/platform-34-ext7_r02.zip -O /tmp/sdk.zip && \
#     unzip /tmp/sdk.zip -d $ANDROID_HOME && \
#     rm /tmp/sdk.zip && \
#     yes | sdkmanager --licenses


FROM --platform=linux ubuntu:latest

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
# ENV JAVA_HOME=/usr/lib/jvm/sapmachine-17-jdk-amd64
ENV JAVA_HOME=/opt/jdk-17.0.9+9
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH
ENV PATH=${JAVA_HOME}/bin:${PATH}


WORKDIR /app

RUN groupadd -r developer && \
    useradd -r -g developer -m -d /home/developer developer && \
    # Change app ownership
    chown -R developer:developer /app && \
    # Create the sudoers directory
    mkdir -p /etc/sudoers.d && \
    # Allow the 'developer' user to run sudo commands without a password prompt
    echo 'developer ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/developer


RUN mkdir -p /home/developer/.ssh
COPY .ssh /home/developer/.ssh
RUN chown -R developer:developer /home/developer/.ssh && \
    chmod 600 /home/developer/.ssh/personal_github


RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    # zip \
    unzip \
    xz-utils \
    libglu1-mesa \
    wget \
    # gnupg \
    clang \
    cmake \
    ninja-build \
    pkg-config \ 
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    # libgconf-2-4 \
    zsh \
    chromium-browser \
    qemu-user-static \
    sudo && \
    # Clean Up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=android_stage $ANDROID_HOME $ANDROID_HOME
COPY --from=android_stage $ANDROID_SDK_ROOT $ANDROID_SDK_ROOT
COPY --from=android_stage $JAVA_HOME $JAVA_HOME

# Copy ARM dynamic linker to the image
# COPY ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3

# Set QEMU_LD_PREFIX to help QEMU locate libraries
# ENV QEMU_LD_PREFIX /usr/arm-linux-gnueabihf

# Copy Java binary and other necessary files
# COPY qemu-arm /usr/bin/qemu-arm
# COPY openjdk-armhf /usr/lib/jvm/java-8-openjdk-armhf

# Specify QEMU interpreter and run Java command
# CMD ["qemu-arm", "-L", "$QEMU_LD_PREFIX", "/usr/lib/jvm/java-8-openjdk-armhf/bin/java", "--version"]



ENV PATH="/usr/local/flutter/bin:${PATH}"
RUN git clone -b 3.16.9 https://github.com/flutter/flutter.git /usr/local/flutter && \
    flutter channel stable && \
    chown -R developer:developer /usr/local/flutter && \
    apt-get update && \
    apt-get clean && \
    # USER developer
    flutter doctor -v && \
    flutter config --no-analytics && \
    flutter precache && \
    chown -R developer:developer /usr/local/flutter/bin/cache


USER developer

EXPOSE 8080 5000

RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# **** Post Create Command ****
USER root
COPY post_create_command.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/post_create_command.sh && \
    chown -R developer:developer /usr/local/bin/post_create_command.sh

# CMD ["sh"]
# CMD ["/usr/local/bin/post_create_command.sh"]

RUN mkdir -p /workspaces/multichoice && \
    chown -R developer:developer /workspaces/multichoice



USER developer
