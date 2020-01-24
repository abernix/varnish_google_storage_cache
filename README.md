# README

### CLI

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
the maximum time specified in the grace period (defined in the `default.vcl`
configuration as `beresp.grace`) has elapsed.

Of course, this local container should have a persisted file cache in order to
survice failures within local infrastructure during an GCS outage.  I thought this
was still possible with Varnish (and it seems it technically is), but it's [no
longer actively supported or recommended](https://varnish-cache.org/docs/trunk/phk/persistent.html#phk-persistent).

Had I realized this before I started making this example, I would have used Ngnix,
but the idea should be similar.
