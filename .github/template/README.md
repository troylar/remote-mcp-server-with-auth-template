# {{project_name}}

A [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) server built with Cloudflare Workers, featuring GitHub OAuth authentication and modular tool architecture.

## 🚀 Quick Start

This template provides a production-ready foundation for building MCP servers with:

- **🔐 GitHub OAuth Authentication** - Secure user authentication
- **🛠️ Modular Tool Architecture** - Easy to extend with new tools
- **☁️ Cloudflare Workers** - Global deployment and scaling
- **📊 Database Integration Ready** - PostgreSQL support included
- **🛡️ Security Best Practices** - Built-in validation and sanitization
- **📈 Monitoring Ready** - Optional Sentry integration

## Key Features

- **Modular Architecture**: Clean separation of tools in `src/tools/`
- **Dual Transport Support**: Both `/mcp` (streamable HTTP) and `/sse` (legacy) endpoints
- **Role-Based Access**: GitHub username-based permissions
- **Production Ready**: Includes monitoring, error handling, and security features

## Getting Started

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy the example environment file and configure your settings:

```bash
cp .dev.vars.example .dev.vars
```

Edit `.dev.vars` with your configuration:

```env
# GitHub OAuth (required)
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
COOKIE_ENCRYPTION_KEY=your_random_encryption_key

# Database Connection (if using database tools)
DATABASE_URL=postgresql://username:password@localhost:5432/database_name

# Optional: Sentry monitoring
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id
NODE_ENV=development
```

### 3. Set Up GitHub OAuth

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create a new OAuth App:
   - **Application name**: `{{project_name}} (Local Development)`
   - **Homepage URL**: `http://localhost:8792`
   - **Authorization callback URL**: `http://localhost:8792/callback`
3. Copy the Client ID and generate a Client Secret
4. Update your `.dev.vars` file with these values

### 4. Generate Encryption Key

```bash
openssl rand -hex 32
```

Copy the output to `COOKIE_ENCRYPTION_KEY` in your `.dev.vars` file.

### 5. Run Locally

```bash
npm run dev
```

Your MCP server will be available at `http://localhost:8792`

### 6. Test with MCP Inspector

```bash
npx @modelcontextprotocol/inspector@latest
```

Connect to:
- **Preferred**: `http://localhost:8792/mcp` (streamable HTTP)
- **Alternative**: `http://localhost:8792/sse` (legacy SSE)

## Project Structure

```
src/
├── auth/                 # Authentication handlers
├── database/            # Database connection and utilities
├── tools/               # MCP tool implementations
│   ├── register-tools.ts # Tool registration
│   └── *.ts             # Individual tool files
├── types.ts             # TypeScript type definitions
└── index.ts             # Main server entry point
```

## Adding New Tools

1. Create a new file in `src/tools/` (e.g., `my-tool.ts`)
2. Implement your tool following the existing patterns
3. Register it in `src/tools/register-tools.ts`

Example tool structure:

```typescript
import { z } from "zod";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

export function registerMyTool(server: McpServer, env: Env, props: Props) {
  server.setRequestHandler(
    "tools/call",
    z.object({
      name: z.literal("myTool"),
      arguments: z.object({
        // Define your tool parameters here
        input: z.string(),
      }),
    }),
    async (request) => {
      // Implement your tool logic here
      return {
        content: [
          {
            type: "text",
            text: `Processed: ${request.arguments.input}`,
          },
        ],
      };
    }
  );
}
```

## Deployment

### 1. Install Wrangler CLI

```bash
npm install -g wrangler
wrangler login
```

### 2. Create KV Namespace

```bash
wrangler kv namespace create "OAUTH_KV"
```

Update `wrangler.jsonc` with the KV ID.

### 3. Deploy

```bash
npm run deploy
```

### 4. Set Production Secrets

```bash
wrangler secret put GITHUB_CLIENT_ID
wrangler secret put GITHUB_CLIENT_SECRET
wrangler secret put COOKIE_ENCRYPTION_KEY
wrangler secret put DATABASE_URL
```

## Development

- **Local Development**: `npm run dev`
- **Type Checking**: `npm run type-check`
- **Testing**: `npm test`
- **Deployment**: `npm run deploy`

## Customization

### Update Project Name

1. Update `package.json` name field
2. Update `wrangler.jsonc` name field
3. Update GitHub OAuth app settings
4. Update any references in documentation

### Add New Dependencies

```bash
npm install your-package
```

### Configure Additional Services

Edit `wrangler.jsonc` to add:
- Database bindings
- KV namespaces
- AI bindings
- Service bindings

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 