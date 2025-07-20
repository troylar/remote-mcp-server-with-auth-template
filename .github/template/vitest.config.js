import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'miniflare',
    environmentOptions: {
      bindings: {
        OAUTH_KV: 'test-kv',
        AI: 'test-ai',
      },
      kvNamespaces: ['OAUTH_KV'],
      ai: true,
    },
    setupFiles: ['./tests/setup.ts'],
  },
}); 