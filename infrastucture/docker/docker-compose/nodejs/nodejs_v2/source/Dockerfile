FROM node:12

# Create node_modules and set full user permissions on it
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# Create app directory
WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install
# if you build you code for production
# RUN npm ci --ony=production

# Bundle app source
COPY --chown=node:node . .

EXPOSE 8080

CMD ["node", "app.js"]