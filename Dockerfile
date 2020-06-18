
#TRIAL WITH PYTHON ALPINE -- START
#FROM python:3-alpine
#NOTE: there no apk in readthedocs
#RUN apk --no-cache add git make
#TRIAL WITH PYTHON ALPINE -- END

FROM readthedocs/build:6.0

#avoiding, setting them takes time in Actions
# Set default locale for the environment
#ENV LC_ALL C.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8
#LABEL "com.github.actions.name"="Builds Sphinx sites"
#LABEL "com.github.actions.description"="Builds a Sphinx based project"
#LABEL "com.github.actions.icon"="globe"
#LABEL "com.github.actions.color"="green"
#LABEL "repository"="http://github.com/DavidLeoni/jupman"


ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]