web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -c 1 -q default -q mailers
