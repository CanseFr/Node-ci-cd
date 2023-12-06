FROM node:20.10
WORKDIR /usr/src/app
COPY ./package.json .
RUN npm install -y
COPY . .
EXPOSE 3000
CMD ["node","app.js"]
