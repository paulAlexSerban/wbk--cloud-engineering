FROM node:18

# Create app directory
WORKDIR /usr/src/app

COPY package.json ./

RUN yarn && yarn cache clean --force
# if you build you code for production
# RUN yarn install --production

# Bundle app source
COPY . .

ARG CONTAINER_PORT
ENV CONTAINER_PORT=$CONTAINER_PORT

EXPOSE $CONTAINER_PORT

# define the command to run your app usng CMD
CMD ["node", "src/server.js"]