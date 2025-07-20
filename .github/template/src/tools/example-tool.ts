import { z } from "zod";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import type { Props } from "../types.js";

// Environment interface (defined in worker-configuration.d.ts)
interface Env {
  OAUTH_KV: KVNamespace;
  AI: any;
  GITHUB_CLIENT_ID: string;
  GITHUB_CLIENT_SECRET: string;
  COOKIE_ENCRYPTION_KEY: string;
  DATABASE_URL?: string;
  SENTRY_DSN?: string;
  NODE_ENV?: string;
}

/**
 * Example MCP Tool
 * 
 * This is a simple example tool that demonstrates how to create new tools
 * for your MCP server. You can use this as a starting point for your own tools.
 */
export function registerExampleTool(server: McpServer, env: Env, props: Props) {
  server.tool(
    "exampleTool",
    "A simple example tool that demonstrates how to create new tools for your MCP server. Processes text with different formatting options.",
    {
      message: z.string().describe("The message to process"),
      format: z.enum(["uppercase", "lowercase", "titlecase"]).optional().default("titlecase").describe("How to format the output"),
      repeat: z.number().min(1).max(10).optional().default(1).describe("Number of times to repeat the message")
    },
    async ({ message, format, repeat }) => {
      
      // Process the message based on format
      let processedMessage = message;
      switch (format) {
        case "uppercase":
          processedMessage = message.toUpperCase();
          break;
        case "lowercase":
          processedMessage = message.toLowerCase();
          break;
        case "titlecase":
          processedMessage = message
            .split(" ")
            .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
            .join(" ");
          break;
      }
      
      // Repeat the message if requested
      const finalMessage = processedMessage.repeat(repeat);
      
      return {
        content: [
          {
            type: "text",
            text: `Example Tool Result: ${finalMessage}`,
          },
        ],
      };
    }
  );
} 