# Universe Beauty Supply - Docker Deployment

This guide explains how to build and run the Universe Beauty Supply website using Docker.

## Prerequisites

- Docker installed on your system ([Download Docker](https://www.docker.com/get-started))

## Building the Docker Image

To build the Docker image using multi-stage build, run the following command in the project directory:

```bash
docker build -t universe-beauty-supply .
```

### Build Specific Stage (Optional)
To build only the builder stage for testing:

```bash
docker build --target builder -t universe-beauty-builder .
```

### Build with BuildKit (Recommended)
For faster builds with better caching:

```bash
DOCKER_BUILDKIT=1 docker build -t universe-beauty-supply .
```

## Running the Container

### Basic Run
To run the container on port 80:

```bash
docker run -d -p 80:80 --name universe-beauty universe-beauty-supply
```

### Run on Custom Port
To run on a different port (e.g., 8080):

```bash
docker run -d -p 8080:80 --name universe-beauty universe-beauty-supply
```

Then access the website at `http://localhost:8080`

## Docker Commands

### View running containers
```bash
docker ps
```

### Stop the container
```bash
docker stop universe-beauty
```

### Start the container
```bash
docker start universe-beauty
```

### Remove the container
```bash
docker rm universe-beauty
```

### View container logs
```bash
docker logs universe-beauty
```

### Check container health
```bash
docker inspect --format='{{.State.Health.Status}}' universe-beauty
```

### Access health endpoint
```bash
curl http://localhost/health
```

### Remove the image
```bash
docker rmi universe-beauty-supply
```

## Docker Compose (Optional)

For easier management, you can use Docker Compose. Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "80:80"
    container_name: universe-beauty
    restart: unless-stopped
```

Then use:

```bash
# Start the service
docker-compose up -d

# Stop the service
docker-compose down
```

## Features

- **Multi-Stage Build**: Optimized build process with separate build and production stages
- **Lightweight**: Uses nginx:alpine (only ~23MB final image)
- **Security**: 
  - Runs as non-root user (nginx)
  - Multiple security headers included
  - Minimal attack surface
- **Performance**: 
  - Gzip compression enabled with optimized settings
  - Static asset caching (30 days)
  - Access logs disabled for static assets
- **Health Checks**: Built-in health check endpoint at `/health`
- **Production Ready**: Optimized for production deployment

## Deployment

### Deploy to Cloud Platforms

#### AWS ECS / Azure Container Instances / Google Cloud Run
1. Push your image to a container registry (Docker Hub, AWS ECR, etc.)
2. Deploy using the platform's container service

#### Digital Ocean / Linode
1. Create a Droplet/VPS
2. Install Docker
3. Pull and run your image

## Troubleshooting

If the container doesn't start:
```bash
docker logs universe-beauty
```

If port 80 is already in use:
```bash
# Use a different port
docker run -d -p 8080:80 --name universe-beauty universe-beauty-supply
```

## Support

For issues related to the website, contact Universe Beauty Supply.
