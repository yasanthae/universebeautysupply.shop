#!/bin/bash

# Deployment script for Universe Beauty Supply
# Run this on your server (e2145098@sugersense-demo)

echo "🌟 Deploying Universe Beauty Supply..."

# Stop and remove existing container if it exists
docker stop universe-beauty-supply 2>/dev/null
docker rm universe-beauty-supply 2>/dev/null

# Pull the latest image
echo "📥 Pulling latest image..."
docker pull yasanthae/universe-beauty-supply:latest

# Run the container
echo "🚀 Starting container..."
docker run -d \
  -p 8080:8080 \
  --name universe-beauty-supply \
  --restart unless-stopped \
  --health-cmd="wget --quiet --tries=1 --spider http://localhost:8080/health || exit 1" \
  --health-interval=30s \
  --health-timeout=3s \
  --health-retries=3 \
  yasanthae/universe-beauty-supply:latest

# Wait for container to be healthy
echo "⏳ Waiting for container to be healthy..."
sleep 5

# Check status
docker ps -a | grep universe-beauty-supply

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your website is running at: http://localhost:8080"
echo "💊 Health check: http://localhost:8080/health"
echo ""
echo "Useful commands:"
echo "  View logs:      docker logs -f universe-beauty-supply"
echo "  Check health:   docker inspect --format='{{.State.Health.Status}}' universe-beauty-supply"
echo "  Stop:           docker stop universe-beauty-supply"
echo "  Restart:        docker restart universe-beauty-supply"
