#!/bin/bash
set -e
bundle install
if [ "$IS_WORKER" ]; then
  bundle exec sidekiq -C /myapp/config/sidekiq.yml
else
  bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
  bundle exec rake db:create RAILS_ENV=test
  bundle exec rake db:schema:load RAILS_ENV=test
fi
rm -f /myapp/tmp/pids/server.pid
exec "$@"
