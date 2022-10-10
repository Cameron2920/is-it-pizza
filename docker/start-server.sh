#!/bin/bash
bundle exec rake db:prepare
bundle exec puma -p 8080