
You don't need to install anything, to start using *cheatly.khulnasoft.com*.
The only tool that you need is *curl*, which is typically installed
in every system. In the rare cases when *curl* is not installed,
there should be one of its alternatives in the system: *wget*, *wget2*,
*httpie*, *ftp* (with HTTP support), *fetch*, etc.

There are two cases, when you want to install *cheatly.khulnasoft.com* locally:

1. You plan to use it off-line, without Internet access;
2. You want to use your own cheat sheets (additionally, or as a replacement).

In this case you need to install cheatly.khulnasoft.com locally.

## How to install cheatly.khulnasoft.com locally

To use cheatly.khulnasoft.com offline, you need to:

1. Install it,
2. Fetch its data sources.

If you already have the cheatly.khulnasoft.com cli client locally,
you can use it for the standalone installation.
Otherwise it must be installed first.

```
    curl https://cheatly.khulnasoft.com/:cheatly.khulnasoft.com > ~/bin/cheatly.khulnasoft.com
    chmod +x ~/bin/cheatly.khulnasoft.com
```

Now you can install cheatly.khulnasoft.com locally:

```
    cheatly.khulnasoft.com --standalone-install
```

During the installation process, cheatly.khulnasoft.com and its
data sources will be installed locally.

By default `~/.cheatly.khulnasoft.com` is used as the installation
directory.

![cheatly.khulnasoft.com standalone installation](https://user-images.githubusercontent.com/3875145/57986904-ef3f1b80-7a7a-11e9-9531-ef37ec74b03a.png)

If you don't plan to use Redis for caching,
switch the caching off in the config file:

```
    $ vim ~/.cheatly.khulnasoft.com/etc/config.yaml
    cache:
      type:   none
```

or with the environment variable `CHEATLY_CACHE_TYPE=none`.

## Update cheat sheets

Cheat sheets are fetched and installed to `~/.cheatly.khulnasoft.com/upstream`.
To keep the cheat sheets up to date,
run the `cheatly.khulnasoft.com` `update-all` command on regular basis.
Ideally, add it to *cron*:

```
0 5 0 0 0 $HOME/.cheatly.khulnasoft.com/ve/bin/python $HOME/.cheatly.khulnasoft.com/lib/fetch.py update-all
```

In this example, all information sources will be updated
each day at 5:00 local time, on regular basis.

## cheatly.khulnasoft.com server mode

Your local cheatly.khulnasoft.com installation is full-fledged, and it can
handle incoming HTTP/HTTPS queries.

To start cheatly.khulnasoft.com in the server mode, run:

```
$HOME/.cheatly.khulnasoft.com/ve/bin/python $HOME/.cheatly.khulnasoft.com/bin/srv.py
```

You can also use `gunicorn` to start the cheatly.khulnasoft.com server.


## Docker

You can deploy cheatly.khulnasoft.com as a docker container.
Use `Dockerfile` in the source root directory, to build the Docker image:

```
docker build .
```

## Limitations

Some cheat sheets not available in the offline mode
for the moment. The reason for that is that to process some queries,
cheatly.khulnasoft.com needs to access the Internet itself, because it does not have
the necessary data locally. We are working on that how to overcome
this limitation, but for the moment it still exists.

## Mac OS X Notes

### Installing Redis

To install Redis on Mac OS X (using `brew`):

```
$ brew install redis
$ ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
$ redis-cli ping
PONG
```
