FROM ubuntu:24.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    sudo \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (needed for Supabase CLI to communicate with Docker daemon)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install Supabase CLI
# Using the official install script which typically installs to /usr/local/bin or similar available on PATH
RUN curl -sL https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz | tar -xz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/supabase

# Set working directory
WORKDIR /app

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]
