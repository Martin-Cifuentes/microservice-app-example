FROM node:14-bullseye

# instalar python2 + make + g++
RUN apt-get update && apt-get install -y python2 make g++ && \
    ln -s /usr/bin/python2 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

CMD ["npm", "start"]

