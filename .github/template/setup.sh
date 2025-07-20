#!/bin/bash

# MCP Server Template Setup Script
# This script helps you set up your new MCP server after creating it from the template

set -e

echo "🚀 Setting up your MCP server..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: This script must be run from a git repository"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed. Please install npm first."
    exit 1
fi

echo "📦 Installing dependencies..."
npm install

# Check if .dev.vars exists
if [ ! -f ".dev.vars" ]; then
    echo "📝 Creating .dev.vars file from example..."
    if [ -f ".dev.vars.example" ]; then
        cp .dev.vars.example .dev.vars
        echo "✅ Created .dev.vars file"
        echo "⚠️  Please edit .dev.vars with your actual configuration values"
    else
        echo "❌ Error: .dev.vars.example not found"
        exit 1
    fi
else
    echo "✅ .dev.vars file already exists"
fi

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "📦 Installing Wrangler CLI..."
    npm install -g wrangler
fi

# Check if user is logged into Cloudflare
echo "🔐 Checking Cloudflare authentication..."
if ! wrangler whoami &> /dev/null; then
    echo "⚠️  You're not logged into Cloudflare. Please run: wrangler login"
    echo "   This will open a browser window for authentication."
fi

echo ""
echo "🎉 Setup complete! Next steps:"
echo ""
echo "1. 📝 Edit .dev.vars with your configuration:"
echo "   - GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET from GitHub OAuth app"
echo "   - COOKIE_ENCRYPTION_KEY (generate with: openssl rand -hex 32)"
echo "   - DATABASE_URL (if using database features)"
echo ""
echo "2. 🔐 Create GitHub OAuth app at: https://github.com/settings/developers"
echo "   - Application name: Your project name"
echo "   - Homepage URL: http://localhost:8792"
echo "   - Authorization callback URL: http://localhost:8792/callback"
echo ""
echo "3. 🗄️  Create KV namespace (for production):"
echo "   wrangler kv namespace create OAUTH_KV"
echo "   Then update wrangler.jsonc with the KV ID"
echo ""
echo "4. 🚀 Run locally:"
echo "   npm run dev"
echo ""
echo "5. 🧪 Test with MCP Inspector:"
echo "   npx @modelcontextprotocol/inspector@latest"
echo "   Connect to: http://localhost:8792/mcp"
echo ""
echo "📚 For more information, see the README.md file" 