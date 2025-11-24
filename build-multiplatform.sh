#!/bin/bash

# Build script for Universe Beauty Supply
# Builds multi-platform Docker image for AMD64 and ARM64

echo "🏗️  Building Universe Beauty Supply Docker Image..."
echo ""

# Login to Docker Hub (if not already logged in)
echo "🔐 Checking Docker Hub login..."
docker login

echo ""
echo "📦 Building multi-platform image..."
echo "   Platforms: linux/amd64, linux/arm64"
echo "   Tag: yasanthae/universe-beauty-supply:latest"
echo ""

# Build and push multi-platform image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t yasanthae/universe-beauty-supply:latest \
  --push \
  .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. SSH to your server: ssh e2145098@sugersense-demo"
    echo "   2. Run deployment: ./deploy-to-server.sh"
    echo ""
    echo "   Or run this one-liner:"
    echo "   ssh e2145098@sugersense-demo 'cd ~/universe-beauty-supply && ./deploy-to-server.sh'"
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
