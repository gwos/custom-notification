# Custom notification service


This container is based from the Debian release of nginx:perl and uses nginx/fcgi and a custom script as an example. The custom script is simple, it just logs to stderr what notifications are sent to it, it is a log-only method which is intended to always return a 200 OK, if given a valid payload. The log functionality is intended to be cleared out with each container restart (or, rotated more often depending on docker configuration), since the audit log of GroundWork Messenger provides logs of this as well.


The payload for the example as well as for any custom scripts comes from the GroundWork Messenger curl method, including all headers or a selection as the GroundWork administrator decides.


It is meant to be a base image which a customer can customize and commit as they would like, to include changing around the ports or adding additional scripts along with their dependencies as well.


It is intended that a customer will be able to add their own scripts and dependencies to this container, and even patch it if they wish to do so.


## Getting image

### Getting image by download

```
docker load groundworkdevelopment/custom-notification:latest
```

In case of Dockerhub service does not available on the system host
the image can be loaded and exported on another host.

```
docker save -o custom-notifications.tar groundworkdevelopment/custom-notification:latest
```


### Getting image by build

Update Dockerfile to include additional dependencies.

```
docker build -t groundworkdevelopment/custom-notification:featured .
```


## Docker Compose example

```
services:
  custom-notification:
    image: groundworkdevelopment/custom-notification:latest
    ports:
      - "5151:5151"  # Bind port to host for testing
    volumes:
      - ./cgi-bin/:/usr/lib/cgi-bin/  # Mount folder with custom scripts
```
