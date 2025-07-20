import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import type { Props } from "../types";
import { registerDatabaseTools } from "./database-tools";
import { registerExampleTool } from "./example-tool";

/**
 * Register all MCP tools based on user permissions
 */
export function registerAllTools(server: McpServer, env: Env, props: Props) {
	// Register database tools
	registerDatabaseTools(server, env, props);
	
	// Register example tool (demonstrates how to add new tools)
	registerExampleTool(server, env, props);
	
	// Future tools can be registered here
	// registerOtherTools(server, env, props);
}