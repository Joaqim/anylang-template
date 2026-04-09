# my-app workspace recipes

# Install all workspace dependencies
install:
    cd my-app && pnpm install

# Start all dev servers (client + server)
dev-all:
    just my-app::dev-client & \
    just my-app::dev-server & \
    wait

# Start client dev server
dev-client:
    cd my-app && pnpm --filter @my-app/client dev

# Start server dev server
dev-server:
    cd my-app && pnpm --filter @my-app/server dev

# Build all packages
build-all:
    just my-app::build-common
    just my-app::build-client
    just my-app::build-server

build-common:
    cd my-app && pnpm --filter @my-app/common build

build-client:
    cd my-app && pnpm --filter @my-app/client build

build-server:
    cd my-app && pnpm --filter @my-app/server build

# Run all tests
test-all:
    just my-app::test-client
    just my-app::test-server

test-client:
    cd my-app && pnpm --filter @my-app/client test

test-server:
    cd my-app && pnpm --filter @my-app/server test

# Run all typechecks
typecheck-all:
    just my-app::typecheck-common
    just my-app::typecheck-client
    just my-app::typecheck-server

typecheck-common:
    cd my-app && pnpm --filter @my-app/common typecheck

typecheck-client:
    cd my-app && pnpm --filter @my-app/client typecheck

typecheck-server:
    cd my-app && pnpm --filter @my-app/server typecheck

# Clean all build artifacts
clean:
    cd my-app && pnpm -r exec rm -rf dist node_modules
