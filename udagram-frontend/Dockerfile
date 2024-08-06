# Stage 1: Build the frontend application
FROM node:16 AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies and the correct TypeScript version in one step to reduce layers
RUN npm install -g @ionic/cli && \
    npm install --legacy-peer-deps && \
    npm install typescript@3.5.3 --legacy-peer-deps

# Copy the rest of the application files to the container
COPY . .

# Explicitly set the NODE_OPTIONS and build the application
RUN export NODE_OPTIONS=--max_old_space_size=4096 && ionic build

# Stage 2: Serve the application using nginx
FROM nginx:alpine

# Copy built application from Stage 1
COPY --from=build /usr/src/app/www /usr/share/nginx/html