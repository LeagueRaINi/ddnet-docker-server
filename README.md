# Docker file for running a simple ddnet server
server directory is `/ddnet-server`, data is in `/ddnet-server/data`

# How to use:
- download or clone this repository
- go into it and run `docker build -t ddnet-server .`
- start a container with `docker run -d --restart=always -p 8303:8303/udp -t ddnet-server`

# Tested on:
- RaspberryPi 5 using Raspbian64

# Build with:
- Websockets
- Sqlite
- Upnp
