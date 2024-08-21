# バージョンは適宜変更
FROM ruby:2.7.1
# パッケージリストを最新の状態に更新し、vimをインストールする
RUN apt-get update -qq && apt-get install -y vim

RUN mkdir /live-chat-rails
WORKDIR /live-chat-rails
COPY Gemfile /live-chat-rails/Gemfile
COPY Gemfile.lock /live-chat-rails/Gemfile.lock

# RubyGemsを最新バージョンに更新
RUN gem update --system
# Bundlerを最新バージョンに更新
RUN bundle update --bundler

RUN bundle install
COPY . /live-chat-rails

COPY entrypoint.sh /usr/bin/
# entrypoint.shの権限(+x:すべてのユーザーに実行権限を追加)を変更
RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT:Dockerfileの中で、コンテナ起動時に実行するデフォルトのコマンドを設定
ENTRYPOINT ["entrypoint.sh"]

# @          @@          @@          @@          @@          @@          @@          @@          @
# 1
# apt-get update -qq && apt-get install -y vim
# apt-get update -qqパッケージリストを最新の状態に更新するコマンド。
# -qqオプションは、出力を最小限に抑えるためのもの。Dockerfileで頻繁に使われる。
# パッケージをインストールする前に最新のリストを取得することで、最新のバージョンのソフトウェアが確実にインストールされ
# るようにする。
# ------------------------------------------------------------------------------------------------
# apt-get install -y vim
# -yオプションは、すべての確認を自動的に「yes」にする
# 開発中にコンテナ内でテキストファイルを編集する必要がある場合、vimを使えるようにしておくと便利なため、これをインストール