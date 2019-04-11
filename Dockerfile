FROM ubuntu:18.04

# ARG $VERSION
ENV VERSION=2.2.0

# Updates and Preqrequisites
RUN apt-get -qq update \
  && apt-get -y upgrade \
  && apt-get -qq -y install \
      git \
      curl \
      autoconf \
      build-essential \
      ncurses-dev \
      libssl-dev

# Install erlang (Ubuntu 18+)
RUN apt-get install -y erlang

# Install libsodium (Ubuntu 18+)
RUN apt-get install -y libsodium-dev

RUN mkdir -p /.aeternity
WORKDIR /.aeternity

# Clone Aeternity source
RUN git clone https://github.com/aeternity/aeternity.git aeternity_source
WORKDIR /.aeternity/aeternity_source
RUN git checkout tags/v${VERSION}

# Build
RUN make prod-build
RUN make prod-package
RUN tar xf _build/prod/rel/aeternity/aeternity-${VERSION}.tar.gz -C /.aeternity/

WORKDIR /.aeternity
RUN rm -r aeternity_source
RUN chown $USER:$USER /.aeternity/* -R


# Copy confirugation file and 
COPY config/aeternity.yaml /.aeternity/aeternity.yaml
RUN chmod u+x aeternity.yaml

# Check validity of config
RUN bin/aeternity check_config aeternity.yaml

# # Ensure we are in the correect directory
# cd /aeternity/aeternity_source/_build/prod/rel/aeternity/

STOPSIGNAL SIGINT

# COPY /scripts/entrypoint.sh /usr/local/bin
# RUN chmod u+x /usr/local/bin/entrypoint.sh

# CMD ["/bin/aeternity start"]