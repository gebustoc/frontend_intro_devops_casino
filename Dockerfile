FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build


FROM nginx:alpine AS runtime

RUN rm -rf /usr/share/nginx/html/* \
 && rm -f /etc/nginx/conf.d/default.conf

COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/dist/casino-frontend/browser/. /usr/share/nginx/html/

EXPOSE 80