# Use the official Nginx image as the base
FROM nginx:latest

# Copy the SSL certificates and Nginx configuration file
ADD nginx/certs /etc/nginx/certificates/
ADD nginx/conf.d /etc/nginx/conf.d
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for SSL traffic
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
