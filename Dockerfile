FROM ubuntu:19.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ARG PIP_INSTALLS="setuptools wheel pip"
ARG BUILD_DEPS="build-essential \
    libncursesw5-dev \
    libreadline-gplv2-dev \
    libssl-dev \
    libgdbm-dev \
    libc6-dev \
    libsqlite3-dev \
    libbz2-dev \
    ca-certificates \
    zlib1g-dev \
    wget \
    curl \
    git \
    gnupg2 \
    ssh \
    libffi-dev \
    make \
    llvm \
    xz-utils \
    liblzma-dev \
    python-openssl"

ENV HOME  /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

WORKDIR ${HOME}

SHELL ["/bin/bash", "-c"]

RUN echo "deb http://security.ubuntu.com/ubuntu cosmic-security main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y ${BUILD_DEPS}

RUN curl https://pyenv.run | bash \
    && echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc 

RUN pyenv install 2.7.16 && pyenv global 2.7.16 && python -m pip install ${PIP_INSTALLS} --upgrade
RUN apt-get remove libssl-dev -y && apt-get install libssl1.0-dev --no-install-recommends --no-install-suggests -y
RUN pyenv install 3.4.10 && pyenv global 3.4.10 && python -m pip install ${PIP_INSTALLS} --upgrade
RUN apt-get remove libssl1.0-dev -y && apt-get install libssl-dev --no-install-recommends --no-install-suggests -y
RUN pyenv install 3.5.7 && pyenv global 3.5.7 && python -m pip install ${PIP_INSTALLS} --upgrade
RUN pyenv install 3.6.8 && pyenv global 3.6.8 && python -m pip install ${PIP_INSTALLS} --upgrade
RUN pyenv install 3.7.3 && pyenv global 3.7.3 && python -m pip install ${PIP_INSTALLS} --upgrade

RUN python --version

CMD /bin/bash