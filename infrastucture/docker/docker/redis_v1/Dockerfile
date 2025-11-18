# use an existing docker image as a based
FROM alpine

# download and install a dependency
RUN apk add --update redis

# tell the image what to do when it starts as a conatiner
CMD ["redis-server"]