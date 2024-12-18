# Nginx with Cloudflare Origin Certificates

This repository contains a Docker setup for running Nginx with Cloudflare origin certificates. The structure of the repository is as follows:
```
├── docker-compose.yml
├── Dockerfile
├── certs/
  ├── cloudflare-origin-example.cer
  ├── cloudflare-origin-example.csr
  ├── cloudflare-origin-example.key
├── nginx/
  ├── nginx.conf
  ├── README.md
  |── conf.d/
    ├── sites-available/
    │ ├── example.conf
    ├── sites-enabled/
      ├── .empty
      ├── [config].conf
```

## How to Create a New Nginx Configuration File with Cloudflare Origin Certificates

### Step 1: Generate Cloudflare Origin Certificates

1. Log in to your Cloudflare dashboard.
2. Navigate to the SSL/TLS section.
3. Click on "Origin Server" and then "Create Certificate".
4. Follow the prompts to generate a new origin certificate and private key.
5. Download the certificate and key files.

### Step 2: Add the Certificates to the Repository

1. Place the downloaded certificate and key files in the `nginx/certs/` directory.
2. Update the `.gitignore` file to include the new certificate and key files to ensure they are not committed to the repository.

### Step 3: Create a New Nginx Configuration File

1. Create a new configuration file in the `nginx/conf.d/sites-available/` directory. For example, `new-site.conf`.
2. Add the following content to the new configuration file, replacing the placeholders with your actual values:

```conf
server {
    listen 443 ssl;
    server_name yourdomain.com;

    # SSL certificates
    ssl_certificate /etc/nginx/certificates/your-certificate.cer;
    ssl_certificate_key /etc/nginx/certificates/your-key.key;

    # SSL settings (can be customized for stronger security)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:ECDHE-RSA-AES128-GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384';

    # Proxy settings
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port 443;
    }
}

server {
    listen 80;
    server_name yourdomain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}
```

3. Create a symbolic link to the new configuration file in the sites-enabled directory:
```bash
ln -s nginx/conf.d/sites-available/new-site.conf nginx/conf.d/sites-enabled/new-site.conf
```

### Step 4: Build and Run the Docker Container

1. Build the Docker image:
```bash
docker compose build
```

2. Run the Docker container:
```bash
docker compose up -d
```

Your Nginx server should now be running with the new configuration and Cloudflare origin certificates.

### Step 5: Update Cloudflare proxy settings

1. Log in to your Cloudflare dashboard.
2. Navigate to the "SSL/TLS" section.
3. Under "SSL/TLS", go to the "Origin Server" tab.
4. Ensure that the origin certificate you generated is listed.
5. Navigate to the "SSL/TLS" section and set the SSL mode to "Full (strict)".
6. Navigate to the "Edge Certificates" tab and enable "Always Use HTTPS".


## Additional Information

The `nginx.conf` file contains the main Nginx configuration.
The `sites-available` directory contains available site configurations.
The `sites-enabled` directory contains enabled site configurations.
The `certs` directory contains the SSL certificates and keys.

For more information on Nginx configuration and Cloudflare origin certificates, refer to the official documentation:

[Nginx Documentation](https://nginx.org/en/docs/)
[Cloudflare Origin CA Certificates](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca)