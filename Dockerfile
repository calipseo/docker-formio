FROM node:12-alpine

LABEL   org.label-schema.vendor="Food and Agriculture Organization of the United Nations" \
        maintainer="Alfredo Irarrazaval <alfredo.irarrazaval@fao.org>"

ARG API_TAG="v1.90.2"
ARG CLIENT_TAG="v1.5.0"

ENV ROOT_EMAIL=admin@example.com
ENV ROOT_PASSWORD=CHANGEME
ENV MONGO=mongodb://172.16.0.1:27017/formio

# Install required packages to build npm modules
RUN apk --no-cache add \
        python2 \
        make \
        g++ \
        wget && \
    # Download the formio api server
    wget --no-check-certificate \
        "https://github.com/formio/formio/archive/${API_TAG}.tar.gz" \
        -O - | tar -xz -C /tmp && \
    mv "/tmp/formio-"* /srv/formio && \
    # Download the formio manager app repository
    wget --no-check-certificate \
        "https://github.com/formio/formio-app-formio/archive/${CLIENT_TAG}.tar.gz" \
        -O - | tar -xz -C /tmp && \
    mv "/tmp/formio-app-formio-"* /srv/formio/client && \
    # Install npm packages
    npm install \
        -C /srv/formio \
        --only=prod && \
    # Clean up
    rm -rf /tmp/* && \
    apk del \
        python2 \
        make \
        g++ \
        wget

WORKDIR /srv/formio

COPY ./custom-environment-variables.json ./config/
COPY ./entrypoint.js ./

EXPOSE 3001
EXPOSE 8080

CMD [ "node", "entrypoint.js" ]
