### STAGE 1:BUILD ###
# Defining node image to be used
FROM node:18.13 AS build
# Create a Virtual directory inside the docker image
WORKDIR /dist/src/app
# Copy files to virtual directory
COPY package.json package-lock.json ./
# Run command in Vizrtual directory
RUN npm cache clean --force

# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm install && npm run build:production


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:alpine AS ngi

# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder
COPY --from=build /dist/src/app/dist/edge-platform /usr/share/nginx/html
COPY --from=build nginx.conf /etc/nginx/conf.d/default.conf

# Exposing a port, here it means that inside the container
# the app will be using Port 80 while running
EXPOSE 80
