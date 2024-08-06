FROM nginx:alpine

# Copy the custom nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the port nginx is running on
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]