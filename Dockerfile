FROM aeternity/builder as builder

# This Dockerfile is was created by modifying the original
# from the aeternity github repository in order to alter
# the build process from `clone build deploy` to
# `build clone deploy`

# Down load source
RUN mkdir /tmp/app/
RUN git clone https://github.com/aeternity/aeternity.git /tmp/app

WORKDIR /tmp/app

RUN make prod-compile-deps
RUN make prod-build

# Put aeternity node in second stage container
FROM ubuntu:18.04

ENV USERNAME=aeternity

# Deploy application code from builder container
COPY --from=builder /tmp/app/_build/prod/rel/aeternity /home/$USERNAME/node
COPY --from=builder /tmp/app/docker/entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/app/docker/healthcheck.sh /healthcheck.sh
# OpenSSL is shared lib dependency
RUN apt-get -qq update && apt-get -qq -y install libssl1.0.0 curl libsodium23 \
    && ldconfig \
    && rm -rf /var/lib/apt/lists/*

# Aeternity app won't run as root for security reasons
RUN useradd --shell /bin/bash $USERNAME \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME

# Switch to non-root user
USER $USERNAME
ENV SHELL /bin/bash

# Create data directories in advance so that volumes can be mounted in there
# see https://github.com/moby/moby/issues/2259 for more about this nasty hack
RUN mkdir -p /home/$USERNAME/node/data/mnesia \
    && mkdir -p /home/$USERNAME/node/keys

WORKDIR /home/$USERNAME/node

# Erl handle SIGQUIT instead of the default SIGINT
STOPSIGNAL SIGQUIT

EXPOSE 3013 3014 3015 3113

# Should custom configuration be preferred
# COPY ./scripts/entrypoint.sh /entrypoint.sh
# COPY ./scripts/healthcheck.sh /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --timeout=3s CMD /healthcheck.sh