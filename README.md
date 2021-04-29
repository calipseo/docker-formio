# Quick Reference

* **Maintained by**: [Food and Agriculture Organization of the United Nations](https://www.fao.org)
* **Where to get help**: [the Form.io help guide](https://help.form.io/), [the Form.io Github](https://github.com/formio/formio) or [the Form.io Gitter Channel](https://gitter.im/formio/formio)

# Docker for Formio API Server

This is a Dockerfile for the [Formio API Server](https://github.co/srvm/formio/formio).  Dockerfiles building on a specific Formio API Server version are now available as tags.  You can request a specific version using the apporpiate tag, e.g. `calipseo/formio:1.87.0`.  Aside from the Formio API Server, it also includes the [Formio Form Manager](https://github.com/srv/formio/formio-app-formio) application.

## Usage

To run a temporary container with Formio API Server:

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -e "ROOT_EMAIL=admin@example.com" \
  -e "ROOT_PASSWORD=CHANGEME" \
  calipseo/formio
```

To get a specific version of the Formio API Server:

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -e "ROOT_EMAIL=admin@example.com" \
  -e "ROOT_PASSWORD=CHANGEME" \
  calipseo/formio:1.87.0
```

## Configuration Variables

Below are the main variables that you can set within your docker container.  See the [Email Transport](#emailtransport) section for additional possible variables.

| Key | Description | Default |
|:----|:------------|:-------:|
|**API_URL**| The publicly accesible URL for the Formio API Server used to configure the Formio form manager application. | `http://localhost:3001` |
|**APP_URL**| The publicly accessible URL for the Formio Form Manager application. | `http://localhost:3001` |
|**MONGO**| The MongoDB connection string to connect to your remote database. | `mongodb://172.16.0.1:27017` |
| **MONGO_HIGH_AVAILABILITY** | If your database is high availability (like from Mongo Cloud or Compose), then this needs to be set. |  |
| **MONGO_SA** | The mongodb certificate authority used to validate SSL connections. |  |
| **MONGO_SECRET** | The mongo secret used by the Formio API Server to encrypt / decrypt data.  You cannot change this after initialization. | `--- change me now ---` |
| **MONGO_CONFIG** | Provides a way to pass custom MongoDB configurations into the MongoDB connection string. This should be a JSON string, and all the configurations are documented at <https://mongoosejs.com/docs/connections.html#options>. |  |
| **ADMIN_KEY** | An optional key that gives full access to the server including listing all projects. Send in a header with x-admin-key. | |
| **ROOT_EMAIL** | The default email of the super admin account. Only on initial startup of the Formio API Server. | `admin@example.com` |
| **ROOT_PASSWORD** | The default password of the super admin account. Only on initial startup of the Formio API Server. | `CHANGEME` |
| **JWT_SECRET** | The secret password for JWT token encryption. | `--- change me now ---` |
| **JWT_EXPIRE** | The expiration for the JWT Tokens | `240` |
| **EMAIL_OVERRIDE** | Provides a way to point all Email traffic to a server. ||
| **DEBUG** | Adding debugging messages to the server. Use ‘formio.’ for all Form.io messages and ‘.*’ for all debug messages. |  |

## MongoDB

The Formio API Server relies on MongoDB.  You can specify the mongo connection string by defining the `MONGO` environment variables.  The default connection string is `mongodb://172.16.0.1:27017/formio` (**172.16.0.1** is almost always the default host IP).

You can directly specify the connection parameters passing the complete mongodb connection string using the `MONGO` variable:

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -e "MONGO_SECRET=CHANGEME"
  calipseo/formio
```

## Project Template

Once the Formio API Server starts, it will import the default project template provided by the official Formio Form Manager application available [here]('https://github.com/srv/formio/formio-app-formio/blob/master/dist/project.json').  To use your custom project template, you must expose the template file to the container on `/srv/formio/client/dist`.

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -v /path/to/project.json:/srv/formio/client/dist/project.json:ro \
  calipseo/formio
```

## Admin Account

By default the Formio API Server will use the `ROOT_EMAIL` and `ROOT_PASSWORD` environment variables to set up the default admin user account only on the initial startup of the server.  The default user email is `admin@example.com` and the default password is `CHANGEME`.  You may pass on these parameters as environment variables or login to the client application through `http://localhost:3001` using the default credentials and change it yourself.

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -e "ROOT_EMAIL=admin@example.com" \
  -e "ROOT_PASSWORD=CHANGEME" \
  calipseo/formio
```

## Custom Application

The Formio API Server can also host your own web application accesible through port `8080` using ExpressJS. To enable your application, you will need to expose your app directory to the container on `/srv/formio/app/dist`.

```sh
docker run -p 3001:3001 -p 8080:8080 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -v /path/to/my/app:/srv/formio/app/dist:ro \
  calipseo/formio
```

## Email Transport

The Formio API Server allows you to configure different types of email transports which allows you to configure the [Email Action](https://help.form.io/userguide/actions/#action-email).  Use the following environment variables to define the available email transports:

| Key | Description | Default |
|:----|:------------|:-------:|
| **EMAIL_TRANSPORT** | The default email transport type to use (can select either `sendgrid` or `mandrill`).  | |
| **EMAIL_USER** | The default email transport username (**API user** for `sendgrid`). | |
| **EMAIL_PASSWORD** | The default email transport password (**API Key** for `sendgrid` or `madrill`). | |
| **GMAIL_USER** | The GMail transport username. | |
| **GMAIL_PASSWORD** | The Gmail transport password. | |
| **SENDGRID_USER** | The Sendgrid transport API user. | |
| **SENDGRID_KEY** | The Sendgrid transport API key. | |
| **MANDRIL_KEY** | The Mandrill transport API key. | |
| **SMTP_HOST** | The SMTP transport server host. | |
| **SMTP_PORT** | The SMTP transport server port. | |
| **SMTP_SECURE** | Wether the SMTP transport server uses SSL/TLS. | |
| **SMTP_USERNAME** | The SMTP transport username. | |
| **SMTP_PASSWORD** | The SMTP transport password. | |
| **SMTP_ALLOW_UNAUTHORIZED** | Wether the SMTP transport should allow unauthorized / invalid certificates. | |

## Database Connectors

The Formio API Server allows to configure MySQL and MSSQL database connectors.  he SQL Connector Action allows you to integrate form submissions with your own SQL based database.  When a submission is created, it will be created in your database for your consumption via [formio-sql](https://github.co/srvm/formio/formio-sql).  Use the following environment variables to setup your database connector.

| Key | Description | Default |
|:----|:------------|:-------:|
| **MYSQL_HOST** | The MySQL database host. | |
| **MYSQL_PORT** | The MySQL database port. | |
| **MYSQL_DBNAME** | The MySQL database name. | |
| **MYSQL_USER** | The MySQL database user. | `formio` |
| **MYSQL_PASSWORD** | The MySQL database user password. | `CHANGEME` |

## Custom Configuration

The Formio API Server loads its default config located in `/srv/formio/config/default.json` (available [here](https://github.com/formio/formio/blob/master/config/default.json).  You may overwrite this file by exposing your own custom config file to the container or by setting the `NODE_CONFIG` environment variable.

### Using Volumes

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27017/formio" \
  -v /path/to/default.json:/srv/formio/config/default.json:ro \
  calipseo/formio
```

### Using NODE_CONFIG

```sh
docker run -p 3001:3001 \
  -e "MONGO=mongodb://172.16.0.1:27.17/formio" \
  -e "NODE_CONFIG={\"mongoSecret\": \"secret\"}" \
  calipseo/formio
```
