vcl 4.0;

backend default {
  .host = "storage.googleapis.com";
}

sub vcl_backend_response {
  set beresp.grace = 5h;
}

sub vcl_backend_fetch {
  set bereq.http.host = "storage.googleapis.com";
}
