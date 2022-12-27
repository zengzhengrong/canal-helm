FROM alpine
LABEL MAINTAINER="bhg889@163.com"
USER root
WORKDIR /canal-server

COPY ./canal_local_tmp.properties .
COPY ./canal.deployer-1.1.6.tar.gz .
COPY ./startup.sh .
COPY ./entrypoint.sh .

RUN  apk update \
  && apk upgrade \
  && apk add --update openjdk11 tzdata curl unzip bash wget gettext libintl \
  && rm -rf /var/cache/apk/* \
  && tar -zxvf canal.deployer-*.tar.gz \
  && mv startup.sh ./bin/startup.sh \
  && chmod 755 ./bin/startup.sh\
  && chmod +x ./bin/startup.sh \
  && rm -f canal.deployer-*.tar.gz \
  && chmod 755 entrypoint.sh \
  && chmod +x entrypoint.sh


EXPOSE 11110 11111 11112

ENTRYPOINT [ "bash", "-c", "./entrypoint.sh" ]