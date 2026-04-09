import { UserSchema, MessageSchema } from "@my-app/common";

const user = UserSchema.parse({
  id: crypto.randomUUID(),
  name: "Joaqim",
  email: "jq@prime",
});

const message = MessageSchema.parse({
  id: crypto.randomUUID(),
  userId: user.id,
  content: "Hello from the server!",
  createdAt: new Date(),
});

console.log("Server starting...");
console.log("User:", user);
console.log("Message:", message);
