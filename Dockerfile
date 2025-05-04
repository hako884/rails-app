# ruby:3.2.1 というベースイメージを取得する
FROM public.ecr.aws/docker/library/ruby:3.2.1

# 必要なパッケージ群を取得する
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client npm && \
    rm -rf /var/lib/apt/lists/\*

# ローカルにあるファイルをコンテナイメージ内にコピーする
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile

# Rails アプリケーションを作成する
RUN bundle install && \
    rails new . -O && \
    sed -i -e "52a\  config.hosts.clear\n  config.web_console.allowed_ips = '0.0.0.0/0'\n  config.action_dispatch.default_headers.delete('X-Frame-Options')" config/environments/development.rb

# Rails を 3000 番ポートで起動する
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]