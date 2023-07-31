FROM node:14
WORKDIR /front
COPY package*.json ./
COPY . ./
RUN npm install 
RUN npm install mysql2
RUN npm install express
RUN npm install wait-on
EXPOSE 3000
CMD ["node", "server.js"]
