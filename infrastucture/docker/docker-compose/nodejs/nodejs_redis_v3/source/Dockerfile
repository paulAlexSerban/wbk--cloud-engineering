# specify the base image
FROM node:alpine

# starting from v15 of Node you need to ad the next line - this will solve `npm ERR! could not detect node from path or package`
WORKDIR /usr/app

COPY package*.json .

# install some dependencies
RUN npm install

ARG DEFAULT_PORT=8080

ENV PORT=${DEFAULT_PORT}

EXPOSE ${PORT}


# copy everything from the curent working directory
COPY ./ ./

# default command
CMD ["npm", "start"]

# run $ `docker build <image_name>`
# run $ `docker run -p 8080:8080 <image_name>`