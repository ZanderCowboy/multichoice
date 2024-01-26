# Use an official Ubuntu runtime as a parent image
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /app

# Create a non-root user
RUN groupadd -r developer && useradd -r -g developer -m -d /home/developer developer

# Set the working directory and change ownership
RUN chown -R developer:developer /app

# Install necessary dependencies
RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set the correct ownership for Flutter directory
RUN chown -R developer:developer /usr/local/flutter


# Switch to the non-root user
USER developer

# Set Flutter bin directory to the user's PATH
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Run flutter doctor to finish the installation and print any missing dependencies
RUN flutter doctor

# Set up the Flutter environment
RUN flutter config --no-analytics
RUN flutter precache

RUN chown -R developer:developer /usr/local/flutter/bin/cache

# Switch to the non-root user
USER developer

# Expose ports for Flutter web development (optional)
EXPOSE 8080 5000

# CMD ["flutter", "run"]
