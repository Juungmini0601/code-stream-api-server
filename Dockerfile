# 빌드 스테이지
FROM node:22-alpine AS builder

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile --prod

RUN pnpm build

# 프로덕션 스테이지
FROM node:22-alpine AS production

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY dist ./dist

EXPOSE 8080

CMD ["node", "dist/main"]
