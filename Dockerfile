
#TRIAL WITH PYTHON ALPINE -- START
#FROM python:3-alpine
#NOTE: there no apk in readthedocs
#RUN apk --no-cache add git make
#TRIAL WITH PYTHON ALPINE -- END

FROM readthedocs/build:6.0

ADD entrypoint.sh /entrypoint.sh

# we need to override RTD 'docs' user:
# https://github.com/readthedocs/readthedocs-docker-images/blob/master/Dockerfile#L136
# because of this:
#https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners#docker-container-filesystem
USER root

ENTRYPOINT ["/entrypoint.sh"]