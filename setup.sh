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

# Check if template variables need to be replaced
if grep -q "{{project_name}}" package.json; then
    echo "🔧 Template variables detected. Let's configure your project..."
    echo ""
    
    # Get project name
    read -p "Enter your project name (e.g., my-mcp-server): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-"my-mcp-server"}
    
    # Get project description
    read -p "Enter project description: " PROJECT_DESCRIPTION
    PROJECT_DESCRIPTION=${PROJECT_DESCRIPTION:-"A Model Context Protocol server with GitHub OAuth authentication"}
    
    # Get author name
    read -p "Enter your name: " AUTHOR_NAME
    AUTHOR_NAME=${AUTHOR_NAME:-"Your Name"}
    
    # Get GitHub username
    read -p "Enter your GitHub username: " GITHUB_USERNAME
    GITHUB_USERNAME=${GITHUB_USERNAME:-"your-username"}
    
    # Get KV namespace ID
    read -p "Enter Cloudflare KV namespace ID (or press Enter to skip): " KV_NAMESPACE_ID
    KV_NAMESPACE_ID=${KV_NAMESPACE_ID:-"your-kv-namespace-id"}
    
    echo ""
    echo "🔄 Replacing template variables..."
    
    # Replace variables in files
    find . -type f \( -name "*.json" -o -name "*.md" -o -name "*.jsonc" \) -exec sed -i.bak \
        -e "s/{{project_name}}/$PROJECT_NAME/g" \
        -e "s/{{project_description}}/$PROJECT_DESCRIPTION/g" \
        -e "s/{{author_name}}/$AUTHOR_NAME/g" \
        -e "s/{{github_username}}/$GITHUB_USERNAME/g" \
        -e "s/{{kv_namespace_id}}/$KV_NAMESPACE_ID/g" {} \;
    
    # Clean up backup files
    find . -name "*.bak" -delete
    
    echo "✅ Template variables replaced!"
    echo ""
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