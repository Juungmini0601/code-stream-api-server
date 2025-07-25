# 빌드 스테이지
FROM node:22-alpine AS builder

RUN npm install -g pnpm

WORKDIR /app

# 의존성 파일 복사
COPY package.json pnpm-lock.yaml ./

# 모든 의존성 설치 (dev dependencies 포함)
RUN pnpm install --frozen-lockfile

# 소스 코드 복사
COPY . .

# 애플리케이션 빌드
RUN pnpm build

# 프로덕션 의존성만 다시 설치
RUN pnpm install --frozen-lockfile --prod

# 프로덕션 스테이지
FROM node:22-alpine AS production

WORKDIR /app

# 빌드된 결과물과 프로덕션 의존성 복사
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 8080

CMD ["node", "dist/main"]
