FROM node:14

WORKDIR /frontend

COPY frontend/package.json .
COPY frontend/src/index.js .

RUN  npm install

EXPOSE 8000

CMD ["node", "index.js"]
