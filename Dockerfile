# ======================================
# Stage 1: Build Stage
# ======================================
FROM alpine:latest AS builder

# Set working directory
WORKDIR /build

# Copy all website files
COPY index.html .
COPY styles.css .
COPY script.js .
COPY images/ ./images/

# Optional: Install optimization tools and optimize assets
RUN apk add --no-cache \
    imagemagick \
    && echo "Build stage complete"

# Optimize images (optional - reduces image sizes)
# RUN find images -type f \( -name "*.jpg" -o -name "*.jpeg" \) -exec mogrify -strip -interlace Plane -quality 85 {} \;

# ======================================
# Stage 2: Production Stage
# ======================================
FROM nginx:alpine AS production

# Add metadata labels
LABEL maintainer="Universe Beauty Supply"
LABEL description="Universe Beauty Supply - Wholesale Beauty Products Website"
LABEL version="1.0"

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy website files from builder stage
COPY --from=builder /build/index.html /usr/share/nginx/html/
COPY --from=builder /build/styles.css /usr/share/nginx/html/
COPY --from=builder /build/script.js /usr/share/nginx/html/
COPY --from=builder /build/images/ /usr/share/nginx/html/images/

# Create nginx configuration for non-root user
RUN mkdir -p /tmp/nginx && \
    chown -R nginx:nginx /tmp/nginx

# Create custom nginx.conf for non-root user
COPY <<EOF /etc/nginx/nginx.conf
pid /tmp/nginx/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    # Use temporary paths that nginx user can write to
    client_body_temp_path /tmp/nginx/client_temp;
    proxy_temp_path /tmp/nginx/proxy_temp;
    fastcgi_temp_path /tmp/nginx/fastcgi_temp;
    uwsgi_temp_path /tmp/nginx/uwsgi_temp;
    scgi_temp_path /tmp/nginx/scgi_temp;

    server {
        listen 8080;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        # Enable gzip compression
        gzip on;
        gzip_vary on;
        gzip_min_length 1024;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json image/svg+xml;

        # Cache static assets
        location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg)\$ {
            expires 30d;
            add_header Cache-Control "public, immutable";
            access_log off;
        }

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;

        # Main location block
        location / {
            try_files \$uri \$uri/ /index.html;
        }

        # Handle 404 errors
        error_page 404 /index.html;

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 8080 (non-privileged port for non-root user)
EXPOSE 8080

# Add healthcheck (updated for port 8080)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/health || exit 1

# Use non-root user for security (nginx alpine already includes nginx user)
USER nginx

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
