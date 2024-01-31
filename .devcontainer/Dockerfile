
FROM --platform=linux ubuntu:latest
# FROM --platform=linux alpine:latest

WORKDIR /app

RUN groupadd -r developer && \
    useradd -r -g developer -m -d /home/developer developer && \
    # Change app ownership
    chown -R developer:developer /app


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
    # libglu1-mesa \
    wget \
    # gnupg \
    clang \
    cmake \
    ninja-build \
    pkg-config \ 
    # libgtk-3-dev \
    # libgconf-2-4 \
    zsh \
    chromium-browser && \
    # Clean Up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


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
