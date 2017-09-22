# use base image
FROM alpine:3.6

MAINTAINER didlich <didlich@t-online.de>

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.2.1.Final
ENV JBOSS_HOME /opt/jboss/wildfly

#http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz

RUN set -x \
    && apk update \
    && apk add --no-cache openjdk8 wget tar tzdata \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd "/tmp" \
    && wget http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && tar xzvf wildfly-$WILDFLY_VERSION.tar.gz \
    && mkdir -p /opt/jboss \
    && adduser -D -h /opt/jboss jboss \
    && mv /tmp/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && ${JBOSS_HOME}/bin/add-user.sh -u wildfly -p wildfly -s \
    && rm -rf "/tmp/"* \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
