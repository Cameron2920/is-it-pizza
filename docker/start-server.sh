#!/bin/bash
bundle exec rake db:migrate
bundle exec unicorn -c config/unicorn.rb -p 8080