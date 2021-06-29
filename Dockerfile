FROM alpine:3.14

ARG MC_VERSION="1.17"
ARG JAVA_VERSION="16"
ENV MC_VERSION=${MC_VERSION}

# Copy in the server starting script
COPY startserver.sh /opt/startserver.sh
RUN chmod +x /opt/startserver.sh

# Download dependencies
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >>/etc/apk/repositories
RUN apk update
RUN apk add bash wget git openjdk${JAVA_VERSION}

# Download and build Spigot
RUN mkdir -p /opt/spigot
WORKDIR /opt/spigot
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar --rev ${MC_VERSION}

# Set up groups
RUN addgroup spigot
RUN chmod -R 0775 ./
RUN chgrp -R 0775 ./

RUN apk del wget git openjdk${JAVA_VERSION}
RUN apk add openjdk${JAVA_VERSION}-jre
RUN rm BuildTools.jar

CMD [ "/opt/startserver.sh" ]