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

RUN mkdir -p ~/.aeternity/node
WORKDIR /.aeternity
RUN chown $USER:$USER ~/.aeternity/* -R

# Clone Aeternity source
RUN git clone https://github.com/aeternity/aeternity.git aeternity_source
WORKDIR /.aeternity/aeternity_source
RUN git checkout tags/v${VERSION}

# Build
RUN make prod-build
RUN make prod-package
RUN tar xf _build/prod/rel/aeternity/aeternity-${VERSION}.tar.gz -C ~/.aeternity/node


# RUN cp ~/.aeternity/aeternity_source/_build/prod/rel/aeternity/bin/* ~/.aeternity/

WORKDIR /.aeternity 



COPY config/aeternity.yaml /.aeternity/aeternity.yaml
RUN chmod u+x aeternity.yaml
RUN ~/.aeternity/node/bin/aeternity check_config /.aeternity/aeternity.yaml

# Check validity of config
# cd /aeternity/node
# bin/aeternity check_config aeternity.yaml
# bin/aeternity start

# # Ensure we are in the correect directory
# cd /aeternity/aeternity_source/_build/prod/rel/aeternity/

# # make prod-package
# ./aeternity start

# # Once the packaging is done, the package is created in the _build/prod/rel/aeternity/ directory, e.g. _build/prod/rel/aeternity/aeternity-${VERSION:?}.tar.gz.
# # cd _build/prod/rel/aeternity/
# # To deploy the package for example in ~/aeternity/node one should just unarchive it to that directory:

# # mkdir -p ~/aeternity/node

# # ~/_build/prod/rel/aeternity start