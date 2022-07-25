# Generated by: Neurodocker version 0.7.0+0.gdc97516.dirty
# Latest release: Neurodocker version 0.8.0
# Timestamp: 2022/07/25 10:15:04 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker

FROM python:3.9-buster

USER root

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN mkdir -p /home/neuro/my_app

COPY [".", "/home/neuro/my_app"]

WORKDIR /home/neuro/my_app

RUN pip install -r requirements.txt

RUN pip install .

CMD ["my_app"]

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "python:3.9-buster" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir -p /home/neuro/my_app" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        ".", \
    \n        "/home/neuro/my_app" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "workdir", \
    \n      "/home/neuro/my_app" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "pip install -r requirements.txt" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "pip install ." \
    \n    ], \
    \n    [ \
    \n      "entrypoint", \
    \n      "my_app" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
