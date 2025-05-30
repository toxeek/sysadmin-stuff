#FROM - Image to start building on.
FROM ubuntu:22.04

RUN apt update
RUN apt-get install -y vim
RUN rm -rf /var/lib/apt/lists/*

#RUN - Runs a command in the container
RUN echo "Hello world" > /tmp/hello_world.txt

#CMD - Identifies the command that should be used by default when running the image as a container.
CMD ["cat", "/tmp/hello_world.txt"]