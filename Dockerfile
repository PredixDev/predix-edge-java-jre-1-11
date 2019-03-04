FROM openjdk:11.0.1 as builder

RUN pwd
RUN whoami
RUN printenv

#list the modules, just for readability
RUN java --list-modules

#you can get even smaller by only including the modules your JAR needs.
#Run e.g. jdeps --list-deps FlightRecorder.jar
#OR if you have dependent modules, get the java modules those modules need - jdeps --module-path /opt/javafx-sdk-11/lib --add-modules=javafx.controls --list-deps FlightRecorder.jar

#Omitted to decrease size - java.smartcardio
RUN jlink \
    --add-modules java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.sql.rowset,java.transaction.xa,java.xml,java.xml.crypto,java.se\
    --verbose \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /opt/jre-minimal

RUN du -sh /opt/*

#OpenJDK has issues and delivers a gigantic libjvm.so.  Running strip shrinks it.
FROM alpine:latest as builder2
RUN apk add  binutils
COPY --from=builder /opt/jre-minimal /opt/jre-minimal
RUN strip -p --strip-unneeded /opt/jre-minimal/lib/server/libjvm.so


FROM panga/alpine:3.7-glibc2.25
LABEL maintainer="Predix Edge Apps"
LABEL hub="https://hub.docker.com"
LABEL org="https://hub.docker.com/u/predixedge"
LABEL repo="predix-edge-java-jre-1-11"
LABEL version="1.0.4"
LABEL support="https://forum.predix.io"
LABEL license="https://github.com/PredixDev/predix-docker-samples/blob/master/LICENSE.md"

COPY --from=builder2 /opt/jre-minimal /opt/jre-minimal

ENV LANG=C.UTF-8 \
    PATH=${PATH}:/opt/jre-minimal/bin

#Example of how to launch an App with modules
#ADD modules /opt/app/modules
#ARG JVM_OPTS
#ENV JVM_OPTS=${JVM_OPTS}
#CMD java ${JVM_OPTS} --upgrade-module-path /opt/app/modules --module spring.petclinic

ENV JAVA_HOME=/opt/java
ENV PATH="$PATH:$JAVA_HOME/bin"

RUN java -version

#if you want something to test out uncomment this. Requires that you compile it from your laptop before running docker build
#COPY ./Test.class .
#ENTRYPOINT ["java Test"]
