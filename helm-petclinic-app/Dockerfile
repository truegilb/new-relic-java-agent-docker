# Docker.load - load test
FROM debian:latest
RUN apt-get update && apt-get install -y curl
RUN mkdir -p /work
COPY ./curl-loop.sh /work
WORKDIR /work 
RUN chmod +x curl-loop.sh
CMD [ "/work/curl-loop.sh" ]
