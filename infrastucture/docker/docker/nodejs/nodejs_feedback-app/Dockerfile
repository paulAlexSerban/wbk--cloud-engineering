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

# anonymous volume used to store temporary files
# useful for improving performance
VOLUME ["/src/temp"]

EXPOSE $CONTAINER_PORT

CMD [ "yarn", "start" ]