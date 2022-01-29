#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

GEM_FILE=/usr/src/app/Gemfile
if [ -f "$GEM_FILE" ]; then
  echo "bundle install..."
  bundle check || bundle install --jobs 4
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"