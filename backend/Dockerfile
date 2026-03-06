# Multi-stage Docker build for NestJS backend
# Build context must be the repo root (for npm workspaces)
FROM node:20-alpine AS builder

WORKDIR /app

# Copy root package files for workspace resolution
COPY package.json package-lock.json ./

# Copy workspace package.jsons
COPY backend/package.json ./backend/
COPY api/package.json ./api/

# Install all workspace dependencies
RUN npm install

# Copy full source for api (shared types) and backend
COPY api ./api
COPY backend ./backend

# Build the shared api package first
RUN cd api && npm run build

# Prisma v7 reads DATABASE_URL from prisma.config.ts via process.env
# Provide a dummy URL just for client generation (no actual connection needed)
ENV DATABASE_URL="postgresql://dummy:dummy@localhost:5432/dummy"

# Generate Prisma client and build backend
RUN cd backend && npx prisma generate
RUN cd backend && npm run build

# --- Production stage ---
FROM node:20-alpine AS runner
WORKDIR /app

# Copy the hoisted node_modules from root (workspaces hoist deps to root)
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/backend/package.json ./
COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/backend/prisma ./prisma
COPY --from=builder /app/backend/prisma.config.ts ./prisma.config.ts

EXPOSE 3000

# DATABASE_URL will be provided by docker-compose at runtime
CMD ["/bin/sh", "-c", "npx prisma db push --accept-data-loss && node dist/src/main"]
