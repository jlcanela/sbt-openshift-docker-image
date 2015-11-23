# SBT OpenShift Docker Image

[![Circle CI](https://circleci.com/gh/AXA-GROUP-SOLUTIONS/sbt-openshift-docker-image/tree/0.13.9.svg?style=shield)](https://circleci.com/gh/AXA-GROUP-SOLUTIONS/sbt-openshift-docker-image/tree/0.13.9)
[![DockerHub](https://img.shields.io/badge/docker-axags%2Fsbt--openshift-008bb8.svg)](https://hub.docker.com/r/axags/sbt-openshift/)
[![Image Layers](https://badge.imagelayers.io/axags/sbt-openshift:0.13.9.svg)](https://imagelayers.io/?images=axags/sbt-openshift:0.13.9)

`axags/sbt-openshift` is a base Docker image that should be used to run SBT-based applications in an OpenShift environment.

This image use the [axags/java-openshift](https://hub.docker.com/r/axags/java-openshift/) base-image, and installs [SBT](http://www.scala-sbt.org/) on top of it (not only the SBT launcher, but also all the SBT libs).

## Using it

Here is a sample `Dockerfile` that can be used to build a "fat" JAR file with SBT, and then run it with Java:

```
FROM axags/sbt-openshift:0.13.9

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
