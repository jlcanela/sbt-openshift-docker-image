FROM axags/java-openshift

MAINTAINER https://github.com/AXA-GROUP-SOLUTIONS/sbt-openshift-docker-image

# SBT Version
ENV SBT_VERSION=0.13.9 \
    SBT_HOME=/opt/sbt \
    PATH=${PATH}:/opt/sbt/bin

# Download and unarchive SBT
RUN curl -jksSL https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | gunzip -c - | tar -xf - -C /opt \
 && rm -f ${SBT_HOME}/bin/sbt.bat \
 && rm -f ${SBT_HOME}/conf/sbtconfig.txt

COPY sbtopts ${SBT_HOME}/conf/sbtopts

# Force the SBT launcher to retrieve all the SBT libs
RUN [ "sbt", "eval 1+1" ]

VOLUME [ "/var/sbt", "/var/ivy2" ]
