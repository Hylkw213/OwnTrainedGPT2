FROM rocm/dev-ubuntu-22.04:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    sudo \
    git \
    vim \
    nano \
    htop \
    cmake \
    build-essential \
    python3-pip \
    python3-dev \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y rocm-dev rocm-utils && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip setuptools wheel build twine

RUN ln -s /usr/bin/python3 /usr/bin/python

# Install PyTorch for ROCm first
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0

# Install compatible NumPy and SciPy versions first
RUN pip3 install "numpy>=1.17.3,<1.25.0" "scipy>=1.9.0,<1.12.0"

# Install other Python packages
RUN pip3 install \
    pandas \
    matplotlib \
    jupyter \
    notebook \
    soundfile \
    tqdm \
    transformers \
    tiktoken

# Create single entrypoint script
COPY <<EOF /usr/local/bin/entrypoint.sh
#!/bin/bash

# Execute any command passed to the script, or start bash if no arguments
if [ \$# -eq 0 ]; then
    exec /bin/bash
else
    exec "\$@"
fi
EOF

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

SHELL ["/bin/bash", "-c"]