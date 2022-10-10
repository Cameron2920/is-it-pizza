FROM ruby:2.7.2
MAINTAINER cam <cam@tuq.ca>
USER root
RUN apt update
RUN apt install -y nodejs
RUN mkdir /var/app
WORKDIR /var/app
RUN useradd -ms /bin/bash app-user
COPY . .
RUN gem install bundler
RUN bundle install
RUN chown -R app-user:app-user .
USER app-user
EXPOSE 8080
CMD "./docker/start-server.sh"
