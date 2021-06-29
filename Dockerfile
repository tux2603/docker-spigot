FROM alpine:3.14

ARG MC_VERSION="1.17"
ENV MC_VERSION=${MC_VERSION}

# Copy in the server starting script
COPY startserver.sh /opt/startserver.sh
RUN chmod +x /opt/startserver.sh

# Download dependencies
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >>/etc/apk/repositories
RUN apk update
RUN apk add wget git openjdk16-jdk

# Download and build Spigot
RUN mkdir -p /opt/spigot
WORKDIR /opt/spigot
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar --rev ${MC_VERSION}

# Set up groups
RUN addgroup spigot
RUN chmod -R 0775 ./
RUN chgrp -R 0775 ./

CMD [ "/opt/startserver.sh" ]