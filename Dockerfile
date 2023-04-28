ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Inheriting host proxy arguments
ENV HTTP_PROXY=${HTTP_PROXY}
ENV http_proxy=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV https_proxy=${HTTPS_PROXY}

# Avoid annoying pycache files
ENV PYTHONDONTWRITEBYTECODE=yes

# Setting proxy everywhere
ARG PROFILE_PROXY_PATH=/etc/profile.d/42-hproxy.sh
RUN echo "export HTTP_PROXY=${HTTP_PROXY}" | tee -a ${PROFILE_PROXY_PATH}
RUN echo "export HTTPS_PROXY=${HTTP_PROXY}" | tee -a ${PROFILE_PROXY_PATH}
RUN echo "export http_proxy=${HTTP_PROXY}" | tee -a ${PROFILE_PROXY_PATH}
RUN echo "export https_proxy=${HTTP_PROXY}" | tee -a ${PROFILE_PROXY_PATH}

# For tzdata batch installation
ENV DEBIAN_FRONTEND=noninteractive

# Remove apt-utils warning
RUN apt-get update \
    && apt-get install -y apt-utils 2> /dev/null \
    && rm -rf /var/lib/apt/lists/*

# Enable manpages, etc.
RUN yes | unminimize

# Essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        sudo \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Useful tools
RUN apt-get update && apt-get install -y --no-install-recommends \
        file \
        ftp \
        less \
        tree \
    && rm -rf /var/lib/apt/lists/*

# Packages for build
RUN apt-get update && apt-get install -y --no-install-recommends \
        bison \
        flex \
        gdb \
        libreadline-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Adding non-root user
ARG USER_ID
ARG GROUP_ID
ENV USER_NAME=tony
RUN addgroup --gid ${GROUP_ID} ${USER_NAME}
RUN adduser --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password --gecos "" ${USER_NAME}
RUN adduser ${USER_NAME} sudo
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo >> /etc/sudoers
RUN echo "Defaults:${USER_NAME} env_keep += \"http_proxy https_proxy ftp_proxy all_proxy no_proxy\"" >> /etc/sudoers

# Using non-root user
USER ${USER_NAME}
RUN touch ~/.sudo_as_admin_successful
ENV WORKDIR /home/${USER_NAME}
WORKDIR ${WORKDIR}
