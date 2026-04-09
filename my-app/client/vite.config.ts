import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@my-app/common": path.resolve(__dirname, "../common/src"),
    },
  },
  test: {
    globals: true,
    environment: "jsdom",
    setupFiles: ['./src/vitest.d.ts'],
  },
});
