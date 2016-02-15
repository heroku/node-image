# Heroku Node.js Docker Image

This image is for use with the [Heroku Docker CLI plugin](https://github.com/heroku/heroku-docker).

Public auto builds for this variant can be found at https://hub.docker.com/r/binarytales/heroku-nodejs/

The repository for this variant can found at https://github.com/Binarytales/heroku-nodejs

## Changes from heroku/docker-nodejs

https://github.com/heroku/docker-nodejs

- Binaries are now verified in the same manner as they are in the official Docker Node builds
https://github.com/nodejs/node#verifying-binaries
https://github.com/nodejs/docker-node

- This version removes the `ONBUILD` commands so you will need to set up your Dockerfile accordingly (see 'Usage')
TODO: I plan on adding `:onbuild` variants in the same way the official Docker Node project does  

## Docker Hub settings

The Docker Hub build is set to auto build when both branches and tags are pushed to the Github repository.

In this way the `lts` and `latest` tags point to the latest LTS and Stable Node versions and then specific
versions are available as version number tags

It is also set to rebuild when the parent image at https://hub.docker.com/r/heroku/cedar/ is rebuilt.
This hasn't happened yet and so I'm not totally sure exactly which builds get rebuilt (all versions, just latest)?


## Usage

The Dockerfile in your project should look something like this for basic usage

```
FROM FROM binarytales/heroku-nodejs:5.6.0

ADD package.json /app/user/
RUN /app/heroku/node/bin/npm install
ADD . /app/user/
```

#Original README

## Usage

Your project must contain the following files:

- `package.json`
- `Procfile` (see [the Heroku Dev Center for details](https://devcenter.heroku.com/articles/procfile))

Then, create an `app.json` file in the root directory of your application with
at least these contents:

```json
{
  "name": "Your App's Name",
  "description": "An example app.json for heroku-docker",
  "image": "heroku/nodejs"
}
```

Install the heroku-docker toolbelt plugin:

```sh-session
$ heroku plugins:install heroku-docker
```

Initialize your app:

```sh-session
$ heroku docker:init
Wrote Dockerfile
Wrote docker-compose.yml
```

And run it with Docker Compose:

```sh-session
$ docker-compose up web
```

The first time you run this command, `npm` will download all dependencies into
the container, build your application, and then run it. Subsequent runs will
use cached dependencies (unless your `package.json` file has changed).

You'll be able to access your application at `http://<docker-ip>:8080`, where
`<docker-ip>` is either the value of running `boot2docker ip` if you are on Mac
or Windows, or your localhost if you are running Docker natively.

For boot2docker users:

```
$ open "http://$(boot2docker ip):8080"
```

## Hacking

To test changes locally, you can edit this image and rebuild it,
replacing the `heroku/node` image on your machine:

```
docker build -t heroku/node .
```

To return to the official image:

```
docker pull heroku/node
```
