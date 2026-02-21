# Stage 1: Build the React application
FROM node:20-alpine AS build

WORKDIR /app

# Copy root package.json and lockfile (assuming npm workspaces)
COPY package.json package-lock.json ./

# Copy workspace package.jsons
COPY web-ui/package.json ./web-ui/
COPY api/package.json ./api/

# Install dependencies (workspaces)
RUN npm ci

# Copy full source
COPY api ./api
COPY web-ui ./web-ui

# Build the shared api package
RUN cd api && npm run build

# Build the Vite React app
ENV VITE_API_URL=/api/v1
RUN cd web-ui && npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Copy the built assets
COPY --from=build /app/web-ui/dist /usr/share/nginx/html

# Copy a custom Nginx configuration to handle React Router navigation
COPY web-ui/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
