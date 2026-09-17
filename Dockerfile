# Калькулятор — статика (index.html, sw.js, icons) плюс крошечный Node-сервер,
# который отдаёт её и собирает курсы на /api/rates. Зависимостей из npm нет
# вообще (только встроенные модули Node 22), поэтому ни package.json, ни
# npm ci здесь нет — образ это просто исходники поверх node:22-alpine.
FROM node:22-alpine

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080
# HOST по умолчанию в server.js — 127.0.0.1, то есть «только этот компьютер».
# В контейнере это значит «только изнутри контейнера»: проброс порта с хоста
# упирался бы в connection refused при полностью рабочем приложении.
ENV HOST=0.0.0.0

COPY server.js sw.js index.html manifest.webmanifest ./
COPY lib ./lib
COPY icons ./icons

# Не от root: пользователь node есть в базовом образе, права на запись не нужны.
USER node

EXPOSE 8080

CMD ["node", "server.js"]
