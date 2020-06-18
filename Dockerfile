
#TRIAL WITH PYTHON ALPINE -- START
FROM python:3-alpine
#NOTE: there no apk in readthedocs
RUN apk --no-cache add git make
#TRIAL WITH PYTHON ALPINE -- END

#FROM readthedocs/build:6.0

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]