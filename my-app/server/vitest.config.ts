import { defineConfig } from "vitest/config";
import path from "path";

export default defineConfig({
  test: {
    globals: true,
  },
  resolve: {
    alias: {
      "@my-app/common": path.resolve(__dirname, "../common/src"),
    },
  },
});
