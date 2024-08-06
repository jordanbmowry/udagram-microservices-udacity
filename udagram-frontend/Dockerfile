# Build Stage
FROM node:16 AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install global dependencies
RUN npm install -g @ionic/cli

# Install project dependencies
RUN npm install --legacy-peer-deps

# Explicitly install the correct TypeScript version locally
RUN npm install typescript@3.5.3 --legacy-peer-deps

# Copy the rest of the application files to the container
COPY . .

# Explicitly set the NODE_OPTIONS before running the build command
RUN export NODE_OPTIONS=--max_old_space_size=4096 && ionic build

# Run Stage
FROM nginx:alpine

# Copy the built files from the build stage
COPY --from=build /usr/src/app/www /usr/share/nginx/html
