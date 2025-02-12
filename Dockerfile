FROM node:18

# Install NVM (Node Version Manager) - optional, as Node 18 is already in the base image
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install 18 && \
    nvm use 18

# Set environment variable for pnpm global installation directory
ENV PNPM_HOME=/pnpm-global
RUN mkdir -p /pnpm-global
ENV PATH=/pnpm-global:$PATH

# Install pnpm globally
RUN npm install -g pnpm

# Install pm2 globally
RUN pnpm install -g pm2

# Clone the repository
RUN git clone https://github.com/dilan-dio4/Keagate

# Copy local.json to the appropriate directory
COPY local.json /Keagate/config/local.js

# Change directory to the root of the cloned repository (Keagate/)
WORKDIR /Keagate
RUN ls
# Ensure that pnpm installs dependencies for all packages in the workspace
RUN pnpm install
# Build the project
RUN pnpm run build

# Start the application using pm2
CMD ["pm2-runtime", "start", "packages/backend/build/index.js", "--name", "Keagate", "--time"]
