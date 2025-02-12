# Use Node.js v18 as the base image (since we need Node.js 18 for pnpm)
FROM node:18

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install 18 && \
    nvm use 18

ENV PNPM_HOME=/pnpm-global
RUN mkdir -p /pnpm-global
ENV PATH=/pnpm-global:$PATH

# Install pnpm globally
RUN npm install -g pnpm

# Install pm2 globally
RUN pnpm install -g pm2

# Set the working directory for the Docker container
WORKDIR /Keagate

# Copy the entire repository into the container, excluding files like .git
COPY . .

# Install all workspace dependencies
RUN pnpm install --frozen-lockfile

# Build the project
RUN pnpm run build

# Start the application using pm2
CMD ["pm2-runtime", "start", "packages/backend/build/index.js", "--name", "Keagate", "--time"]
