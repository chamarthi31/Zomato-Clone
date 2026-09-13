# ---- Build Stage ----
FROM node:18-alpine AS builder

WORKDIR /app

# Fix OpenSSL compatibility with older Webpack/react-scripts
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package files
COPY package*.json ./

# Install all dependencies required for the build
RUN npm ci

# Copy application source
COPY . .

# Build React application
RUN npm run build


# ---- Production Stage ----
FROM nginx:alpine

# Copy React production build to Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Expose HTTP
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]