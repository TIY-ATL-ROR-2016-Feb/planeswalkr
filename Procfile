web: bundle exec puma -p ${PORT:-5000} ./config.ru  
redis: redis-server
worker: QUEUE=* bundle exec rake environment resque:work
