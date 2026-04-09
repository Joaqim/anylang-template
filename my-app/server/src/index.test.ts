import { describe, it, expect } from "vitest";
import request from "supertest";
import { UserSchema, MessageSchema } from "@my-app/common";
import { app } from "./index";

describe("Server validation", () => {
  it("validates user correctly", () => {
    const user = UserSchema.parse({
      id: crypto.randomUUID(),
      name: "Test User",
      email: "test@example.com",
    });
    expect(user.name).toBe("Test User");
  });

  it("validates message correctly", () => {
    const message = MessageSchema.parse({
      id: crypto.randomUUID(),
      userId: crypto.randomUUID(),
      content: "Test message",
      createdAt: new Date(),
    });
    expect(message.content).toBe("Test message");
  });
});

describe("API routes", () => {
  it("GET /api/health returns ok", async () => {
    const res = await request(app).get("/api/health");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("ok");
  });

  it("GET /api/user returns a valid user", async () => {
    const res = await request(app).get("/api/user");
    expect(res.status).toBe(200);
    expect(() => UserSchema.parse(res.body)).not.toThrow();
    expect(res.body.name).toBe("Joaqim");
  });

  it("POST /api/message creates a message", async () => {
    const res = await request(app)
      .post("/api/message")
      .send({ content: "Hello!" });
    expect(res.status).toBe(201);
    expect(res.body.content).toBe("Hello!");
  });
});
