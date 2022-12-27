FROM alpine
LABEL MAINTAINER="bhg889@163.com"
USER root
WORKDIR /canal-admin

COPY ./startup.sh .
COPY ./canal.admin-1.1.6.tar.gz .
COPY ./entrypoint.sh .
COPY ./application-tmp.yml .

RUN  apk update \
  && apk upgrade \
  && apk add --update openjdk11 tzdata curl unzip bash wget gettext libintl \
  && rm -rf /var/cache/apk/* \
  && tar -zxvf canal.admin-*.tar.gz \
  && mv startup.sh ./bin/startup.sh \
  && chmod 755 ./bin/startup.sh\
  && chmod +x ./bin/startup.sh \
  && rm -f canal.admin-*.tar.gz \
  && chmod 755 entrypoint.sh \
  && chmod +x entrypoint.sh

EXPOSE 8089

ENTRYPOINT [ "bash", "-c", "./entrypoint.sh" ]