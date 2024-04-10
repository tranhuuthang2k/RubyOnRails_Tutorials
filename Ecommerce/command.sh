rm -f tmp/pids/server.pid

bundle install

bundle exec rails db:prepare && bundle exec rails s -p 3000 -b 0.0.0.0