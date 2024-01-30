
FROM --platform=linux ubuntu:latest
# FROM --platform=linux alpine:latest

WORKDIR /app

RUN groupadd -r developer
RUN useradd -r -g developer -m -d /home/developer developer

# Set the working directory and change ownership
RUN chown -R developer:developer /app

RUN mkdir -p /home/developer/.ssh
COPY .ssh /home/developer/.ssh
RUN chown -R developer:developer /home/developer/.ssh

RUN apt-get update
RUN apt-get install -y \
    curl \
    git \
    zip \
    unzip \
    xz-utils \
    libglu1-mesa \
    wget \
    gnupg \
    clang \
    cmake \
    ninja-build \
    pkg-config \ 
    libgtk-3-dev \
    libgconf-2-4 \
    zsh \
    chromium-browser

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone -b 3.16.9 https://github.com/flutter/flutter.git /usr/local/flutter
RUN chown -R developer:developer /usr/local/flutter
RUN apt-get update 
RUN apt-get clean


USER developer
# Set Flutter bin directory to the user's PATH
ENV PATH="/usr/local/flutter/bin:${PATH}"

RUN flutter doctor -v
RUN flutter config --no-analytics
RUN flutter precache

RUN chown -R developer:developer /usr/local/flutter/bin/cache
RUN flutter channel stable

USER developer

EXPOSE 8080 5000

RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# **** Post Create Command ****
USER root
# RUN mkdir -p /usr/local/bin
COPY post_create_command.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/post_create_command.sh
RUN chown -R developer:developer /usr/local/bin/post_create_command.sh

# CMD ["sh"]
# CMD ["/usr/local/bin/post_create_command.sh"]

RUN mkdir -p /workspaces/multichoice
RUN chown -R developer:developer /workspaces/multichoice

USER developer
