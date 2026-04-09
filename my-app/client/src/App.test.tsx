import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import App from "./App";

const mockUser = {
  id: "mock-uuid",
  name: "Joaqim",
  email: "jq@prime.example.com",
};

describe("App", () => {
  beforeEach(() => {
    vi.stubGlobal("fetch", vi.fn(() =>
      Promise.resolve({
        json: () => Promise.resolve(mockUser),
      } as Response)
    ));
  });

  it("renders loading state initially", () => {
    render(<App />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it("renders app title", () => {
    render(<App />);
    expect(screen.getByText("My App")).toBeInTheDocument();
  });

  it("shows user data after fetch", async () => {
    render(<App />);
    await waitFor(() => {
      expect(screen.getByText(/hello, joaqim/i)).toBeInTheDocument();
    });
  });
});
