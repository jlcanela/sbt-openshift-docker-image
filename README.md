# SBT OpenShift Docker Image

[![Circle CI](https://circleci.com/gh/vbehar/sbt-openshift-docker-image/tree/master.svg?style=shield)](https://circleci.com/gh/vbehar/sbt-openshift-docker-image/tree/master)
[![DockerHub](https://img.shields.io/badge/docker-vbehar%2Fsbt--openshift-008bb8.svg)](https://hub.docker.com/r/vbehar/sbt-openshift/)
[![Image Layers](https://badge.imagelayers.io/vbehar/sbt-openshift:latest.svg)](https://imagelayers.io/?images=vbehar/sbt-openshift:latest)

`vbehar/sbt-openshift` is a base Docker image that should be used to run SBT-based applications in an OpenShift environment.

This image use the [vbehar/java-openshift](https://hub.docker.com/r/vbehar/java-openshift/) base-image, and installs [SBT](http://www.scala-sbt.org/) on top of it (not only the SBT launcher, but also all the SBT libs).

## Using it

Here is a sample `Dockerfile` that can be used to build a "fat" JAR file with SBT, and then run it with Java:

```
FROM vbehar/sbt-openshift

ENV MYAPP_HOME /opt/myapp

WORKDIR ${MYAPP_HOME}

# SBT required files for downloading dependencies
COPY build.sbt ${MYAPP_HOME}/
COPY project/build.properties project/plugins.sbt ${MYAPP_HOME}/project/
RUN [ "sbt", "update" ]

# Source code, for building the fat JAR file
COPY src ${MYAPP_HOME}/src
RUN [ "sbt", "assembly" ]

CMD [ "java", "-jar", "${MYAPP_HOME}/target/scala-2.11/myapp.jar" ]
```

Note that we copy/build in 2 steps, to benefit from the caching system : if you don't change your dependencies, you won't need to download them for each build.
