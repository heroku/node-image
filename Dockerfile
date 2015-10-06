# Inherit Heroku OS
FROM heroku/cedar:14

# Set Node Version
ENV NODE_ENGINE 4.1.2

# Set the PATH for Node (inc npm) and any installed runnables
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

# Create Node installation directory
RUN mkdir -p /app/heroku/node

# Create Heroky setup directory
RUN mkdir -p /app/.profile.d

# Change to working directory
WORKDIR /app/user

# Install Node
RUN curl -s https://nodejs.org/dist/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

# Make the PATH available to Heroku by export to .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
