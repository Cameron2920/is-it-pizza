FROM ruby:2.7.2
MAINTAINER cam <cam@tuq.ca>
USER root
RUN apt-get update
RUN mkdir /var/app
WORKDIR /var/app
RUN useradd -ms /bin/bash app-user
USER app-user
COPY . .
RUN gem install bundler
RUN bundle install
RUN chmod +x run_docker_server.sh
RUN chmod +x bin/rake
EXPOSE 8080
CMD "./docker/start-server.sh"
