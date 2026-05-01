# multi step build
# first step of the build
FROM node:latest as builder
WORKDIR '/app'
COPY package.json .
RUN npm i
COPY . .
RUN npm run build

# second step of the build
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html