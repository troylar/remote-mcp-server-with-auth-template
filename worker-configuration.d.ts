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