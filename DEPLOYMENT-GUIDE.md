# Universe Beauty Supply - Deployment Guide

## Problem You Encountered

You built the Docker image on an **ARM64 Mac** (Apple Silicon) but tried to run it on an **AMD64 Linux server**. This causes a platform mismatch warning and potential performance/compatibility issues.

## Solution: Multi-Platform Build

Build the image for multiple architectures so it works on both Mac and Linux servers.

---

## Option 1: Quick Fix (On Your Server)

Your container is already running, but with platform emulation. For better performance, rebuild for the correct platform:

### On Your Mac (Local):
```bash
# Login to Docker Hub
docker login

# Build for AMD64 platform specifically
docker buildx build --platform linux/amd64 -t yasanthae/universe-beauty-supply:latest --push .
```

### On Your Server:
```bash
# Pull and run the correct platform image
docker stop universe-beauty-supply
docker rm universe-beauty-supply
docker pull yasanthae/universe-beauty-supply:latest
docker run -d -p 8080:8080 --name universe-beauty-supply --restart unless-stopped yasanthae/universe-beauty-supply:latest
```

---

## Option 2: Multi-Platform Build (Recommended)

This builds for both ARM64 and AMD64, so it works everywhere.

### Step 1: Setup Docker Buildx (One-time setup on Mac)
```bash
# Create a new builder instance
docker buildx create --name multiplatform-builder --use

# Verify builder
docker buildx inspect --bootstrap
```

### Step 2: Build Multi-Platform Image
```bash
# Make the build script executable
chmod +x build-multiplatform.sh

# Run the build script
./build-multiplatform.sh
```

Or manually:
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t yasanthae/universe-beauty-supply:latest \
  --push \
  .
```

### Step 3: Deploy to Server
Copy `deploy-to-server.sh` to your server and run:
```bash
chmod +x deploy-to-server.sh
./deploy-to-server.sh
```

---

## Current Container Management

Your container is running. Here are useful commands:

### Check Status
```bash
docker ps -a | grep universe-beauty-supply
docker logs universe-beauty-supply
docker inspect --format='{{.State.Health.Status}}' universe-beauty-supply
```

### Access the Website
```bash
# On the server
curl http://localhost:8080

# From outside (if port is open)
curl http://YOUR_SERVER_IP:8080
```

### Container Control
```bash
# View logs (live)
docker logs -f universe-beauty-supply

# Stop container
docker stop universe-beauty-supply

# Start container
docker start universe-beauty-supply

# Restart container
docker restart universe-beauty-supply

# Remove container
docker rm -f universe-beauty-supply
```

---

## Using Docker Compose (Alternative)

Update `docker-compose.yml` for the server:

```yaml
version: '3.8'

services:
  web:
    image: yasanthae/universe-beauty-supply:latest
    container_name: universe-beauty-supply
    ports:
      - "8080:8080"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

Then deploy:
```bash
docker-compose up -d
```

---

## Auto-Restart Configuration

Your container is set with `--restart unless-stopped`, which means:

✅ **Automatically restarts** if it crashes  
✅ **Automatically starts** after server reboot  
❌ **Won't restart** if you manually stop it  

### Other restart policies:
- `no` - Never restart (default)
- `always` - Always restart (even if manually stopped)
- `on-failure` - Restart only on failure
- `unless-stopped` - Restart unless manually stopped (recommended)

---

## Monitoring

### Check if container is running:
```bash
docker ps | grep universe-beauty-supply
```

### Check health status:
```bash
docker inspect --format='{{.State.Health.Status}}' universe-beauty-supply
```

### Monitor logs:
```bash
# Last 100 lines
docker logs --tail 100 universe-beauty-supply

# Follow logs in real-time
docker logs -f universe-beauty-supply

# Logs with timestamps
docker logs -t universe-beauty-supply
```

### Check resource usage:
```bash
docker stats universe-beauty-supply
```

---

## Troubleshooting

### Container keeps restarting
```bash
# Check logs
docker logs --tail 50 universe-beauty-supply

# Check inspect output
docker inspect universe-beauty-supply
```

### Port already in use
```bash
# Find what's using port 8080
sudo lsof -i :8080
# or
sudo netstat -tulpn | grep 8080

# Use a different port
docker run -d -p 9090:8080 --name universe-beauty-supply --restart unless-stopped yasanthae/universe-beauty-supply:latest
```

### Platform mismatch warning
Follow Option 1 or Option 2 above to rebuild for the correct platform.

---

## Production Recommendations

1. **Use multi-platform builds** for flexibility
2. **Tag versions** (e.g., v1.0, v1.1) not just `latest`
3. **Set up monitoring** (health checks, logs)
4. **Use Docker Compose** for easier management
5. **Enable firewall** and only expose necessary ports
6. **Use reverse proxy** (nginx/traefik) for HTTPS
7. **Regular backups** of Docker volumes (if any)

---

## Next Steps

- [ ] Rebuild image for AMD64 platform
- [ ] Set up SSL/HTTPS with reverse proxy
- [ ] Configure domain name
- [ ] Set up monitoring/alerting
- [ ] Implement CI/CD pipeline
