#!/bin/bash

# Ensure buildx is set up (optional for single arch, but kept for consistency)
docker buildx create --use
docker buildx inspect --bootstrap

# Define an array of service names, contexts, and tags
services=(
  "reverseproxy:./udagram-reverseproxy:reverseproxy"
  "backend-user:./udagram-api-user:udagram-api-user"
  "backend-feed:./udagram-api-feed:udagram-api-feed"
  "frontend:./udagram-frontend:udagram-frontend:local"
)

# Loop through the services and build each one
for service in "${services[@]}"; do
  name=$(echo $service | cut -d':' -f1)
  context=$(echo $service | cut -d':' -f2)
  tag=$(echo $service | cut -d':' -f3)
  full_image_name="$DOCKER_USERNAME/$tag"  # Use Docker Hub username from environment variables

  echo "Building and pushing $full_image_name from $context"
  
  # Build and push the image for amd64 architecture with quiet output
  docker buildx build --platform linux/amd64 -t $full_image_name $context --push --quiet
  build_result=$?

  if [ $build_result -ne 0 ]; then
    echo "Failed to build and push $full_image_name"
    exit 1
  fi

  # Optionally pull back the image for the current architecture (amd64 in this case)
  docker pull $full_image_name
  pull_result=$?

  if [ $pull_result -ne 0 ]; then
    echo "Failed to pull $full_image_name"
    exit 1
  fi

  # Check if the image was pulled successfully
  if docker images | grep -q $full_image_name; then
    echo "Successfully pulled $full_image_name"
  else
    echo "Failed to pull $full_image_name"
    exit 1
  fi
done
