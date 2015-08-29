---
layout: post
title: docker in artifactory
---

This just a rough draft of notes so that I know what I did when 6
months pass and I forgot how the Docker registry was set up.

------------------------------------------------------------------------

Docker does not work with artifactory out of the box, instead it needs
to be tricked a little bit. Basically, docker expects that every
registry has SSL and artifactory does not do that.

There are two components, 1) setting up the SSL proxy, and 2) setting
up the client registry.

------------------------------------------------------------------------

## Setting Up the SSL Proxy

The artifactory documentation describes setting up everything pretty
easily. The only extra step was having a command to copy/paste for
creating a self-signed SSL key, like this:

```
mkdir /etc/nginx/docker-artifactory
cd /etc/nginx/docker-artifactory
openssl req -x509 -nodes -newkey rsa:2048 -keyout key.pem -out cert.pem -days 36500
```

Then I do the `nginx.conf`:

    server {
      listen 443;
      server_name docker.artifactory.rb;
      ssl on;
      ssl_certificate     docker-artifactory/cert.pem;
      ssl_certificate_key docker-artifactory/key.pem;
      error_log /var/log/nginx/docker.artifactory.rb.error.log;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Original-URI $request_uri;
      proxy_read_timeout 900;
      client_max_body_size 0;
      chunked_transfer_encoding on;
      location / {
        proxy_pass http://ares:8081/artifactory/api/docker/ixl-docker-local/;
      }
    }

As well as adding a DNS entry for `docker.artifactory.rb`.

Having those available for the [rest of the instructions][1] was helpful.

*Note*: If we have an actual CA signed key for SSL, the most painful
parts of client configuration will not be necessary.

See the [documentation][1] for more details.

------------------------------------------------------------------------

## Setting Up the Client Registry

Had to first set up Docker to use an insecure registry.

    sudo systemctl edit --full docker

Needed to add to the end of my `ExecStart` line in the Docker unit file:

    --insecure-registry docker.artifactory.rb

So it looked like:

    ExecStart=/usr/bin/docker -d -H fd:// --insecure-registry docker.artifactory.rb

This is enough to use `docker pull` and download images from
artifactory.

## Setting Up Client Push

There is a little extra you'll need to set up if you want to push
images to the registry.

Artifactory provides a little interface you can use with curl to get a
piece of JSON that you'll include in your `~/.dockercfg`.

    curl --insecure -u username:password "https://docker.artifactory.rb/v1/auth"

If you already have a `~/.dockercfg`, then you'll need to manually
integrate the output of curl with your current config. Since it is
just JSON and we're all engineers, I have faith this present no
insurmountable challenges.

One thing to note is that now when you want to push/pull images from
Artifactory, you **MUST** prefix the image name with the registry
domain. In my particular case, it is `docker.artifactory.rb`.

So, for instance, I wanted to upload the redis image to artifactory.

First, I looked for its image ID in the output of `docker images`,
then I retagged it correctly:

    docker tag 868be653dea3 docker.artifactory.rb/redis:latest

Now I can upload it:

    docker push docker.artifactory.rb/redis:latest

To pull an image from artifactory, it looks the same:

    docker pull docker.artifactory.rb/redis:latest

See the [documentation][1] for more details.


  [1]: http://www.jfrog.com/confluence/display/RTF/Docker+Repositories
