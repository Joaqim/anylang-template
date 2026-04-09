# My App Documentation

## Project Structure

This is a monorepo using pnpm workspaces with the following packages:

- **`@my-app/common`** - Shared types and validation schemas (TypeScript + Zod)
- **`@my-app/client`** - Frontend application (React + Vite + TailwindCSS)
- **`@my-app/server`** - Backend application (Node.js + TypeScript)
- **`docs`** - Project documentation

## Architecture

The common package contains shared data structures and validation logic that both client and server depend on. This ensures type safety and validation consistency across the full stack.

## Development

### Prerequisites

- Node.js (LTS)
- pnpm (v8+)

### Setup

```bash
# Install dependencies
pnpm install

# Start development servers
pnpm --filter @my-app/client dev    # Client dev server
pnpm --filter @my-app/server dev    # Server dev server
```

### Building

```bash
pnpm --filter @my-app/common build
pnpm --filter @my-app/client build
pnpm --filter @my-app/server build
```

### Testing

```bash
# Run all tests
pnpm test

# Run specific package tests
pnpm --filter @my-app/client test
pnpm --filter @my-app/server test
```

## ADRs

See the [ADR directory](./adr/) for Architecture Decision Records.
