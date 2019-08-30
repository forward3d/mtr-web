FROM ruby:2.6.4-alpine

RUN apk --no-cache add mtr libstdc++

WORKDIR /opt/mtr-web
COPY Gemfile* /opt/mtr-web/

RUN \
  apk --no-cache add --virtual build-dependencies g++ musl-dev make ruby-dev git && \
  bundle install && \
  apk del build-dependencies

COPY . .

EXPOSE 4567
CMD ["bundle", "exec", "ruby", "app.rb"]
