# Use a lightweight Linux distribution
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Download the script and then execute it with the version argument
RUN curl -fsSL -o /usr/local/bin/install_fast_linux.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_linux.sh \
    && chmod +x /usr/local/bin/install_fast_linux.sh \
    && /bin/bash /usr/local/bin/install_fast_linux.sh 0.5.6-beta

# Verify installation
RUN fast self:version

# Default command (optional)
CMD ["fast", "help"]
