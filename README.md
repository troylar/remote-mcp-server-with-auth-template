# MCP Server Template with GitHub OAuth

> **🚀 GitHub template for creating production-ready MCP servers!**

This repository serves as a **GitHub template** for building Model Context Protocol (MCP) servers with GitHub OAuth authentication, deployed on Cloudflare Workers.

## 🎯 What This Template Provides

- **🔐 GitHub OAuth Authentication** - Secure user authentication with role-based access
- **☁️ Cloudflare Workers Deployment** - Global edge computing platform
- **🗄️ PostgreSQL Database Integration** - Full database support with connection pooling
- **🛠️ Modular Tool Architecture** - Easy to extend with new MCP tools
- **📝 TypeScript Support** - Full type safety and modern development
- **🔄 Dual Transport Support** - Both `/mcp` (streamable HTTP) and `/sse` (legacy) endpoints
- **🛡️ Security Best Practices** - SQL injection protection, input validation, sanitization
- **📊 Production Monitoring** - Optional Sentry integration
- **🧪 Comprehensive Testing** - Test suite with Vitest and Miniflare

## 🚀 Quick Start

1. **Click "Use this template"** above to create a new repository
2. **Clone and setup**: `git clone <your-repo> && cd <your-repo> && ./setup.sh`
3. **Configure environment**: Copy `.dev.vars.example` to `.dev.vars` and edit
4. **Set up GitHub OAuth**: Create OAuth app at https://github.com/settings/developers
5. **Run locally**: `npm run dev`
6. **Test**: Use MCP Inspector to connect to `http://localhost:8792/mcp`

## 📚 Documentation

- **[Template README](.github/template/README.md)** - Detailed setup and usage guide
- **[Template Guide](.github/template/TEMPLATE_GUIDE.md)** - Comprehensive guide with examples
- **[Template Summary](.github/template/TEMPLATE_SUMMARY.md)** - Quick reference

## 🔗 Useful Links

- [MCP Specification](https://modelcontextprotocol.io/)
- [Cloudflare Workers](https://developers.cloudflare.com/workers/)
- [GitHub OAuth Apps](https://docs.github.com/en/apps/oauth-apps/)
- [MCP Inspector](https://modelcontextprotocol.io/docs/tools/inspector)

## 📄 License

This template is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Ready to build your MCP server? Click "Use this template" above to get started! 🚀**
