#!/bin/bash
# Remove the existing artifacts directory if it exists
[[ -d artifacts/web ]] && rm -r artifacts/web

# Create the necessary directories
mkdir -p artifacts/web

# Copy the contents of the build/web directory to artifacts/web
cp -R build/web/* artifacts/web/
