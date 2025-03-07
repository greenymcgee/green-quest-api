http {
  server {
    listen 80;
    server_name https://green-quest-api-staging.up.railway.app;

    root /rails;

    # Serve static files from /rails/storage
    location /storage/ {
      root /rails;
      autoindex off;
      gzip_static on;
      expires max;
      add_header Cache-Control "public, max-age=31536000";
      try_files $uri $uri/ @rails;
    }

    # Main location: Proxy all other requests to Rails
    location / {
      proxy_pass http://127.0.0.1:3000;  # Forward requests to Rails app
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }

    location @rails {
      proxy_pass http://127.0.0.1:3000;  # Forward requests to Rails app
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
}