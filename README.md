# README

## What?

A caching, reverse proxy setup which proxies all of its incoming requests directly
to `storage.googleapis.com` and will serve "stale" versions in the event that the
origin is unavailable.

## How?

```shell
$ # Change default from https://storage.googleapis.com/engine-partial-schema-prod/
$ export APOLLO_PARTIAL_SCHEMA_BASE_URL="https://stark-forest-20507.herokuapp.com/engine-partial-schema-prod/"
# Start server as usual, however that may be, e.g.:
$ npm start
```

From thereon, requests to the schema registry will hit the local proxy on local
infrastructure first, every time.  The local cache will by default re-validate
against `storage.googleapis.com` on every request.  However, in the event that
the origin `storage.googleapis.com` becomes unavailable, but the "stale" cached
artifact (i.e. the last known representation of it), will still be served until
the maximum time specified in [the grace period](https://varnish-cache.org/docs/trunk/users-guide/vcl-grace.html)
(defined in the `default.vcl` configuration as `beresp.grace`) has elapsed.

Of course, this local container should have a persisted file cache in order to
survice failures within local infrastructure during an GCS outage.  I thought this
was still possible with Varnish (and it seems it technically is), but it's [no
longer actively supported or recommended](https://varnish-cache.org/docs/trunk/phk/persistent.html#phk-persistent).

Had I realized this before I started making this example, I would have used Ngnix,
but the idea should be similar.

## Example

For example, I deployed this (built) container to Heroku and now, by starting the
server with the command in the [**How?**](#How) section above the server would access
this proxy rather than `storage.googleapis.com`.  So for example, rather than
attempting to fetch a partial schema from the usual:

```
https://storage.googleapis.com/engine-partial-schema-prod/d2d1fb25-31ec-4119-a760-20e2f8328a45/current/v1/implementing-services/greeting-service/6b3956c8b966ee8f6b44d6f584c9d2176b34b98e550d7b5af9eff10ce47b4aec2f79038989e14de497a60d3062f3c42c2a58ddc8d916e513ec8c94268b0f0860.json
```

It will fetch from:

```
https://stark-forest-20507.herokuapp.com/engine-partial-schema-prod/d2d1fb25-31ec-4119-a760-20e2f8328a45/current/v1/implementing-services/greeting-service/6b3956c8b966ee8f6b44d6f584c9d2176b34b98e550d7b5af9eff10ce47b4aec2f79038989e14de497a60d3062f3c42c2a58ddc8d916e513ec8c94268b0f0860.json
```

