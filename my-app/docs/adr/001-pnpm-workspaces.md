# ADR-001: Use pnpm Workspaces with TypeScript Project References

### Status
Accepted

### Date
2026-04-09

### Context
We need a monorepo structure that allows:
1. Code sharing between client and server (common types and validation)
2. Type safety across package boundaries
3. Efficient dependency management
4. Fast build times with TypeScript project references
5. Simple developer experience

### Decision
Use pnpm workspaces with TypeScript project references:
- **pnpm** for workspace management (efficient, fast, widely adopted)
- **TypeScript project references** for incremental builds and cross-package type checking
- **Zod** in the common package for runtime validation with TypeScript types
- **Vite** for the client (fast HMR, optimized builds)
- **tsx** for the server (direct TS execution, no build step for dev)

### Consequences
**Benefits:**
- ✅ Shared types and validation via `@my-app/common`
- ✅ Type-safe workspace dependencies with project references
- ✅ Incremental builds (only rebuild changed packages)
- ✅ Efficient disk usage (single `node_modules` at root)
- ✅ Fast dev experience (tsx for server, Vite for client)
- ✅ Clear separation of concerns (common/client/server)

**Trade-offs:**
- ⚠️ Requires pnpm (adds a build dependency)
- ⚠️ TypeScript project references add some config complexity
- ⚠️ Workspace path aliases need to be configured in multiple places (Vite, tsconfig)

### Options Considered

#### Option 1: Monorepo with single package
- **Pros:** Simplest setup, no workspace overhead
- **Cons:** No separation of concerns, harder to scale, mixed client/server code
- **Effort:** low

#### Option 2: npm workspaces with Lerna
- **Pros:** Mature ecosystem, good tooling
- **Cons:** Heavy dependency, slower than pnpm, Lerna adds complexity
- **Effort:** medium

#### Option 3: pnpm workspaces with Turborepo
- **Pros:** Excellent caching, fast CI/CD, great for large monorepos
- **Cons:** Overkill for 3 packages, adds complexity and build step
- **Effort:** high

#### Option 4: pnpm workspaces with TypeScript project references (CHOSEN)
- **Pros:** Efficient, type-safe, simple, fast builds
- **Cons:** Requires pnpm, some TypeScript config boilerplate
- **Effort:** low-medium

### References
- [pnpm workspace documentation](https://pnpm.io/workspaces)
- [TypeScript project references](https://www.typescriptlang.org/docs/handbook/project-references.html)
- [Zod validation library](https://zod.dev/)
