# MCP Server Template Guide

This guide explains how to use this template to create your own MCP server with GitHub OAuth authentication and Cloudflare Workers.

## What This Template Provides

### 🏗️ Architecture
- **Modular Tool System**: Easy to add new MCP tools in `src/tools/`
- **Dual Transport Support**: Both `/mcp` (streamable HTTP) and `/sse` (legacy) endpoints
- **GitHub OAuth Authentication**: Secure user authentication with role-based access
- **Cloudflare Workers**: Global deployment with edge computing
- **TypeScript**: Full type safety and modern development experience

### 🔧 Built-in Features
- **Database Integration**: PostgreSQL support with connection pooling
- **Security**: SQL injection protection, input validation, and sanitization
- **Monitoring**: Optional Sentry integration for production monitoring
- **Testing**: Comprehensive test suite with Vitest
- **Development Tools**: Hot reloading, type checking, and linting

## Quick Start

### 1. Create Repository from Template

1. Click the "Use this template" button on GitHub
2. Choose "Create a new repository"
3. Fill in the repository details
4. Click "Create repository from template"

### 2. Clone and Setup

```bash
git clone https://github.com/your-username/your-mcp-server.git
cd your-mcp-server
./setup.sh
```

### 3. Configure Environment

Edit `.dev.vars` with your configuration:

```env
# Required: GitHub OAuth
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
COOKIE_ENCRYPTION_KEY=your_random_encryption_key

# Optional: Database
DATABASE_URL=postgresql://username:password@localhost:5432/database_name

# Optional: Monitoring
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id
NODE_ENV=development
```

### 4. Set Up GitHub OAuth

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create a new OAuth App:
   - **Application name**: Your project name
   - **Homepage URL**: `http://localhost:8792`
   - **Authorization callback URL**: `http://localhost:8792/callback`
3. Copy the Client ID and generate a Client Secret
4. Update your `.dev.vars` file

### 5. Generate Encryption Key

```bash
openssl rand -hex 32
```

Copy the output to `COOKIE_ENCRYPTION_KEY` in `.dev.vars`.

### 6. Run Locally

```bash
npm run dev
```

Your MCP server will be available at `http://localhost:8792`

### 7. Test with MCP Inspector

```bash
npx @modelcontextprotocol/inspector@latest
```

Connect to `http://localhost:8792/mcp` and authenticate with GitHub.

## Project Structure

```
src/
├── auth/                 # Authentication handlers
│   ├── github-handler.ts # GitHub OAuth implementation
│   └── oauth-utils.ts    # OAuth utility functions
├── database/            # Database connection and utilities
│   ├── connection.ts    # Database connection management
│   ├── security.ts      # SQL injection protection
│   └── utils.ts         # Database utility functions
├── tools/               # MCP tool implementations
│   ├── register-tools.ts # Central tool registration
│   ├── database-tools.ts # Database-related tools
│   └── *.ts             # Individual tool files
├── types.ts             # TypeScript type definitions
└── index.ts             # Main server entry point
```

## Adding New Tools

### 1. Create Tool File

Create a new file in `src/tools/` (e.g., `my-tool.ts`):

```typescript
import { z } from "zod";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { Env, Props } from "../types.js";

export function registerMyTool(server: McpServer, env: Env, props: Props) {
  server.setRequestHandler(
    "tools/call",
    z.object({
      name: z.literal("myTool"),
      arguments: z.object({
        input: z.string().describe("The input to process"),
        options: z.object({
          format: z.enum(["text", "json"]).optional().default("text")
        }).optional()
      }),
    }),
    async (request) => {
      const { input, options = { format: "text" } } = request.arguments;
      
      // Your tool logic here
      const result = `Processed: ${input}`;
      
      return {
        content: [
          {
            type: "text",
            text: result,
          },
        ],
      };
    }
  );
}
```

### 2. Register the Tool

Add your tool to `src/tools/register-tools.ts`:

```typescript
import { registerMyTool } from "./my-tool.js";

export function registerAllTools(server: McpServer, env: Env, props: Props) {
  // Register existing tools
  registerDatabaseTools(server, env, props);
  
  // Register your new tool
  registerMyTool(server, env, props);
}
```

### 3. Add Tool Documentation

Update the README.md to document your new tool:

```markdown
### myTool

**Purpose**: Process input data  
**Access**: All authenticated users  
**Parameters**:
- `input` (string): The input to process
- `options.format` (optional): Output format ("text" or "json")

**Example**:
```json
{
  "name": "myTool",
  "arguments": {
    "input": "Hello World",
    "options": { "format": "json" }
  }
}
```
```

## Authentication and Authorization

### GitHub OAuth Flow

1. User visits MCP server endpoint
2. Server redirects to GitHub OAuth
3. User authorizes the application
4. GitHub redirects back with authorization code
5. Server exchanges code for access token
6. Server gets user information from GitHub
7. User is authenticated and can use MCP tools

### Role-Based Access

The template includes a role-based access system:

- **All authenticated users**: Can use read-only tools
- **Privileged users**: Can use write/modify tools (defined by GitHub username)

To customize access control, modify the authorization logic in your tool implementations.

## Database Integration

### PostgreSQL Setup

The template includes PostgreSQL support with:

- **Connection pooling**: Efficient database connections
- **SQL injection protection**: Built-in security measures
- **Schema discovery**: Automatic table and column information
- **Query validation**: Safe query execution

### Database Tools

Three built-in database tools:

1. **`listTables`**: Discover database schema
2. **`queryDatabase`**: Execute read-only queries
3. **`executeDatabase`**: Execute write operations (privileged users only)

### Custom Database Tools

To add custom database functionality:

```typescript
export function registerCustomDbTool(server: McpServer, env: Env, props: Props) {
  server.setRequestHandler(
    "tools/call",
    z.object({
      name: z.literal("customDbTool"),
      arguments: z.object({
        table: z.string().describe("Table name"),
        action: z.enum(["analyze", "backup", "optimize"]).describe("Action to perform")
      }),
    }),
    async (request) => {
      const { table, action } = request.arguments;
      
      // Your custom database logic here
      const result = await performCustomDbAction(table, action);
      
      return {
        content: [
          {
            type: "text",
            text: `Performed ${action} on ${table}: ${result}`,
          },
        ],
      };
    }
  );
}
```

## Deployment

### 1. Prepare for Production

```bash
# Create KV namespace
wrangler kv namespace create "OAUTH_KV"

# Update wrangler.jsonc with KV ID
# Edit the kv_namespaces section with your KV ID
```

### 2. Set Production Secrets

```bash
wrangler secret put GITHUB_CLIENT_ID
wrangler secret put GITHUB_CLIENT_SECRET
wrangler secret put COOKIE_ENCRYPTION_KEY
wrangler secret put DATABASE_URL
wrangler secret put SENTRY_DSN  # optional
```

### 3. Update GitHub OAuth App

1. Go to your GitHub OAuth app settings
2. Update URLs for production:
   - **Homepage URL**: `https://your-worker.your-subdomain.workers.dev`
   - **Authorization callback URL**: `https://your-worker.your-subdomain.workers.dev/callback`

### 4. Deploy

```bash
npm run deploy
```

### 5. Test Production

```bash
npx @modelcontextprotocol/inspector@latest
```

Connect to `https://your-worker.your-subdomain.workers.dev/mcp`

## Testing

### Run Tests

```bash
# Run all tests
npm test

# Run tests with UI
npm run test:ui

# Run tests once
npm run test:run
```

### Writing Tests

Create test files in `tests/unit/`:

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { registerMyTool } from '../../src/tools/my-tool.js';

describe('MyTool', () => {
  it('should process input correctly', async () => {
    // Your test logic here
    expect(true).toBe(true);
  });
});
```

### Test Environment

The template includes:
- **Miniflare**: Cloudflare Workers testing environment
- **Mock data**: Test fixtures and mocks
- **Type checking**: TypeScript validation in tests

## Monitoring and Debugging

### Sentry Integration

Optional Sentry integration for production monitoring:

1. Create a Sentry account and project
2. Get your DSN from Sentry
3. Add `SENTRY_DSN` to your environment variables
4. Errors and performance data will be sent to Sentry

### Local Debugging

```bash
# Run with debug logging
NODE_ENV=development npm run dev

# Check Cloudflare logs
wrangler tail
```

### Error Handling

The template includes comprehensive error handling:

- **Input validation**: Zod schemas for all inputs
- **SQL injection protection**: Safe database queries
- **Authentication errors**: Proper OAuth error handling
- **Network errors**: Retry logic and fallbacks

## Customization

### Update Project Name

1. Update `package.json` name field
2. Update `wrangler.jsonc` name field
3. Update GitHub OAuth app settings
4. Update any references in documentation

### Add Dependencies

```bash
npm install your-package
```

### Configure Additional Services

Edit `wrangler.jsonc` to add:
- Database bindings (D1, Durable Objects)
- KV namespaces
- AI bindings
- Service bindings
- R2 storage

### Environment-Specific Configuration

Create environment-specific configuration files:

```bash
# Development
.dev.vars

# Production
# Use wrangler secret put for sensitive data
```

## Troubleshooting

### Common Issues

1. **OAuth errors**: Check GitHub OAuth app configuration
2. **Database connection**: Verify DATABASE_URL format
3. **KV namespace**: Ensure KV namespace exists and ID is correct
4. **Port conflicts**: Change port in wrangler.jsonc dev section

### Getting Help

1. Check the [Cloudflare Workers documentation](https://developers.cloudflare.com/workers/)
2. Review the [MCP specification](https://modelcontextprotocol.io/)
3. Check GitHub issues for similar problems
4. Create an issue in the template repository

## Contributing

1. Fork the template repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

## License

This template is licensed under the MIT License. See the [LICENSE](LICENSE) file for details. 