# Get alpine to make it L E A N
FROM alpine:3.8

# Gotta put credit somewhere
LABEL maintainer="Sheldon Rupp <me@shel.io>, Shawn Lutch <shawn@chaoticweg.cc>"

# Put some schema stuff
LABEL \
  org.label-schema.name="discord.sh" \
  org.label-schema.url="https://github.com/ChaoticWeg/discord.sh.git" \
  org.label-schema.vcs-url="https://github.com/ChaoticWeg/discord.sh.git"

# Install the goodies
RUN apk add --no-cache --update \
  bash \
  curl \
  dos2unix

# Teleport to /app
WORKDIR /app

# Copy everything in /app
COPY . /app

# Run dos2unix cause yeah just to make sure
RUN dos2unix /app/discord.sh

# Set entrypoint
ENTRYPOINT ["/bin/bash", "/app/discord.sh"]
