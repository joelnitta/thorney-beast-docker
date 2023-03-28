FROM ubuntu:kinetic

ARG DEBIAN_FRONTEND=noninteractive

### Install APT packages ###
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cmake \
    build-essential \
    autoconf \
    automake \
    libtool \
    git \
    pkg-config \
    openjdk-11-jdk \
    wget \
    openjdk-11-jdk \
  && apt-get clean

# Setup to install other software
ENV APPS_HOME=/apps
RUN mkdir $APPS_HOME
WORKDIR $APPS_HOME

### Install beagle ###
# specify commit to pin version
ENV BEAGLE_VERSION=1d4b21d062999c303d0d8b3e1e306c3d5e81d708
RUN git clone --depth=1 https://github.com/beagle-dev/beagle-lib.git \
  && cd beagle-lib \
  && git checkout $BEAGLE_VERSION \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_INSTALL_PREFIX:PATH=$HOME .. \
  && make install

# Set beagle path variables
RUN echo "export LD_LIBRARY_PATH=${HOME}/lib:${LD_LIBRARY_PATH}" >> /etc/bash.bashrc
RUN echo "PKG_CONFIG_PATH=${HOME}/lib/pkgconfig:${PKG_CONFIG_PATH}" >> /etc/bash.bashrc

### Install pre-release of ThorneyTreeLikelihood BEAST ###
ENV BEAST_VERSION=0.1.2
RUN wget https://github.com/beast-dev/beast-mcmc/releases/download/v1.10.5pre_thorney_v${BEAST_VERSION}/BEASTv1.10.5pre_thorney_${BEAST_VERSION}.tgz \
  && tar -xzf BEASTv1.10.5pre_thorney_${BEAST_VERSION}.tgz \
  && rm BEASTv1.10.5pre_thorney_${BEAST_VERSION}.tgz

ENV PATH=$APPS_HOME/BEASTv1.10.5pre_thorney_${BEAST_VERSION}/bin:$PATH

### Install pre-release of ThorneyTreeLikelihood BEASTgen ###

RUN wget https://github.com/beast-dev/beast-mcmc/releases/download/v1.10.5pre_thorney_v${BEAST_VERSION}/BEASTGen_v0.3pre_thorney.tgz \
  && tar -xzf BEASTGen_v0.3pre_thorney.tgz \
  && rm BEASTGen_v0.3pre_thorney.tgz

ENV PATH=$APPS_HOME/BEASTGen_v0.3pre_thorney/bin:$PATH