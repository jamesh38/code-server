# Use the linuxserver.io code-server image as the base
FROM linuxserver/code-server:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ASDF version manager
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# Set up ASDF environment variables
ENV PATH="/root/.asdf/bin:/root/.asdf/shims:$PATH"

# Source ASDF in the shell
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc

# Install ASDF plugins and versions for Go, Node.js, and Deno
RUN /bin/bash -c "source ~/.asdf/asdf.sh && \
    asdf plugin add golang https://github.com/kennyp/asdf-golang.git && \
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
    asdf plugin add deno https://github.com/asdf-community/asdf-deno.git && \
    asdf install golang latest && asdf global golang latest && \
    asdf install nodejs latest:20 && asdf global nodejs latest:20 && \
    asdf install deno latest && asdf global deno latest"

# Expose the code-server port
EXPOSE 8443
