# TODO(ZK): Add Java to Dockerfile

# FROM sapmachine:latest as android_stage

# ENV ANDROID_HOME=/opt/android-sdk
# ENV ANDROID_SDK_ROOT=/opt/android-sdk
# ENV JAVA_HOME=/opt/jdk-17.0.9+9

# RUN apt-get update && \
#     apt-get install -y \
#     wget \
#     unzip \
#     android-sdk \
#     sdkmanager

# RUN apt install -y openjdk-17-jdk

# RUN wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_arm_linux_hotspot_17.0.9_9.tar.gz -O /tmp/openjdk.tar.gz && \
#     tar xzfv /tmp/openjdk.tar.gz -C /opt/ && \
#     rm /tmp/openjdk.tar.gz

# RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/android-sdk.zip && \
#     unzip /tmp/android-sdk.zip -d $ANDROID_HOME && \
#     rm /tmp/android-sdk.zip
# ENV PATH=$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

# RUN yes | sdkmanager --licenses

# RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"


FROM --platform=linux ubuntu:latest

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV JAVA_HOME=/opt/jdk-17.0.9+9
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$FLUTTER_HOME/bin:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

WORKDIR /app

RUN groupadd -r developer && \
    useradd -r -g developer -m -d /home/developer developer && \
    chown -R developer:developer /app && \
    mkdir -p /etc/sudoers.d && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/developer

RUN mkdir -p /home/developer/.ssh
COPY .ssh /home/developer/.ssh
RUN chown -R developer:developer /home/developer/.ssh && \
    chmod 600 /home/developer/.ssh/personal_github

RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    wget \
    clang \
    cmake \
    ninja-build \
    pkg-config \ 
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    zsh \
    chromium-browser \
    qemu-user-static \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# COPY --from=android_stage $ANDROID_HOME $ANDROID_HOME
# COPY --from=android_stage $ANDROID_SDK_ROOT $ANDROID_SDK_ROOT
# COPY --from=android_stage $JAVA_HOME $JAVA_HOME

RUN git clone -b 3.19.0 https://github.com/flutter/flutter.git /usr/local/flutter && \
    flutter channel stable && \
    chown -R developer:developer /usr/local/flutter && \
    apt-get update && \
    apt-get clean && \
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

RUN mkdir -p /workspaces/multichoice && \
    chown -R developer:developer /workspaces/multichoice

USER developer
