import { describe, it, expect } from "vitest";
import { UserSchema, MessageSchema } from "@my-app/common";

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
