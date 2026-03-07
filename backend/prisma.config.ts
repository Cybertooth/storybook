import "dotenv/config";
import { defineConfig, env } from "prisma/config";

// Read from env to support custom test schemas
const schemaPath = process.env.PRISMA_SCHEMA || "prisma/schema.prisma";

export default defineConfig({
    schema: schemaPath,
    migrations: {
        path: "prisma/migrations",
    },
    datasource: {
        url: env("DATABASE_URL"),
    },
});
