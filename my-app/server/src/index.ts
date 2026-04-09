import express, { type Express } from "express";
import serveStatic from "serve-static";
import { resolve } from "node:path";
import { UserSchema, MessageSchema } from "@my-app/common";

const app: Express = express();
const PORT = process.env.PORT ?? 3000;

app.use(express.json());

// ── API routes ──────────────────────────────────────────────────

app.get("/api/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.get("/api/user", (_req, res) => {
  const user = UserSchema.parse({
    id: crypto.randomUUID(),
    name: "Joaqim",
    email: "jq@prime.example.com",
  });
  res.json(user);
});

app.post("/api/message", (req, res) => {
  const message = MessageSchema.parse({
    id: crypto.randomUUID(),
    userId: req.body.userId ?? crypto.randomUUID(),
    content: req.body.content,
    createdAt: new Date(),
  });
  res.status(201).json(message);
});

// ── Client static files (production) ────────────────────────────

const clientDist = process.env.MYAPP_CLIENT_DIST;
if (clientDist) {
  const root = resolve(clientDist);
  app.use(serveStatic(root));
  // SPA fallback — serve index.html for any unmatched GET route
  app.get("{*splat}", (_req, res) => {
    res.sendFile(resolve(root, "index.html"));
  });
}

// ── Start ───────────────────────────────────────────────────────

app.listen(PORT, () => {
  console.log(`Server listening on http://localhost:${PORT}`);
  if (clientDist) {
    console.log(`Serving client from: ${clientDist}`);
  } else {
    console.log("No MYAPP_CLIENT_DIST set — running API-only mode");
  }
});

export { app };
