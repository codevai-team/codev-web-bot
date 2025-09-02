# Простой Dockerfile для деплоя веб-приложения
# Используется только веб-приложение для упрощения деплоя

FROM node:18-alpine AS base

# Установка зависимостей для Puppeteer
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Указываем Puppeteer использовать установленный Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app

# Этап установки зависимостей
FROM base AS deps
COPY codev/package*.json ./
RUN npm ci --only=production

# Этап сборки
FROM base AS builder
WORKDIR /app
COPY codev/package*.json ./
RUN npm ci
COPY codev/ ./

# Сборка приложения
RUN npm run build

# Продакшн этап
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Создаем пользователя nextjs для безопасности
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Копируем сборку приложения из standalone
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Копируем статические файлы из builder
COPY --from=builder /app/public ./public

# Меняем владельца файлов
RUN chown -R nextjs:nodejs /app

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
