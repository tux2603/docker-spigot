ARG MC_VERSION="1.17"
ARG JAVA_VERSION="16"

FROM alpine:3.14 AS build

ARG MC_VERSION
ARG JAVA_VERSION


# Download dependencies
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >>/etc/apk/repositories
RUN apk update 
RUN apk add bash wget git openjdk${JAVA_VERSION}

# Download and build Spigot
RUN mkdir -p /opt/spigot
WORKDIR /opt/spigot
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar --rev ${MC_VERSION}

FROM alpine:3.14

ARG MC_VERSION
ARG JAVA_VERSION
ENV MC_VERSION=${MC_VERSION}
RUN echo ${MC_VERSION}


RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >>/etc/apk/repositories && apk update
RUN apk add openjdk${JAVA_VERSION}-jre || apk add openjdk${JAVA_VERSION}-jre-headless

# Copy in the server starting script
COPY --from=build /opt/spigot /opt/spigot
COPY startserver.sh /opt/startserver.sh

RUN chmod +x /opt/startserver.sh
RUN mkdir /server && mkdir /server/plugins 
WORKDIR /server


CMD [ "/opt/startserver.sh" ]