#!/usr/bin/env bash
# new-project.sh <template> <app-name>
# Helper script to create a new project with flake template
# Usage: new-project.sh go-cli myapp

set -euo pipefail
TEMPLATE=$1
APP_NAME=$2

mkdir "$APP_NAME" && cd "$APP_NAME"
nix flake init -t "github:joshuablais/project-flakes#$TEMPLATE"
find . -type f -name "*.nix" -exec sed -i "s/#APP_NAME/$APP_NAME/g" {} +
git init && git add .
echo "Ready: $APP_NAME from template $TEMPLATE"
