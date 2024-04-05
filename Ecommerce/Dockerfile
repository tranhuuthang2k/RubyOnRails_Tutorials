# Sử dụng image base có sẵn với Ruby 2.7.2
FROM ruby:2.7.2

RUN apt-get update && apt-get install -y nodejs

# Thiết lập thư mục làm việc
WORKDIR /app

RUN gem install net-imap -v '0.3.7'

RUN gem install nokogiri -v '1.15.6'

# Cài đặt Rails 6.1.4.1
RUN gem install rails -v '6.1.4.1'

# Copy các file cần thiết từ máy host vào container
COPY Gemfile Gemfile.lock ./

# Cài đặt các gem
RUN bundle install

# Copy toàn bộ mã nguồn của ứng dụng vào container
COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
