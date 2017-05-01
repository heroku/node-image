# Inherit Heroku OS
FROM heroku/cedar:14

# Set Node Version
ENV NODE_ENGINE 6.2.2

# Set the PATH for Node (inc npm) and any installed runnables
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

# Add gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

# Create Node installation directory
RUN mkdir -p /app/heroku/node

# Create Heroku setup directory
RUN mkdir -p /app/.profile.d

# Change to working directory
WORKDIR /app/user

# Install Node
RUN curl -SLO "https://nodejs.org/dist/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_ENGINE/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_ENGINE-linux-x64.tar.xz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xJf "node-v$NODE_ENGINE-linux-x64.tar.xz" -C /app/heroku/node --strip-components=1 \
  && rm "node-v$NODE_ENGINE-linux-x64.tar.xz" SHASUMS256.txt.asc

# Make the PATH available to Heroku by export to .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
