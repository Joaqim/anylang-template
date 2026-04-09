import { z } from "zod";

// Example schemas
export const UserSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1).max(100),
  email: z.string().email(),
});

export type User = z.infer<typeof UserSchema>;

export const MessageSchema = z.object({
  id: z.string().uuid(),
  userId: z.string().uuid(),
  content: z.string().min(1).max(5000),
  createdAt: z.date(),
});

export type Message = z.infer<typeof MessageSchema>;
