FROM node:16.2.0
# ENV HOME=/app/vite-project
WORKDIR /live-chat-vuejs
COPY . /live-chat-vuejs
# パッケージリストを更新し、npmおよびVue CLIをインストール
RUN apt-get update && \
    # npmのバージョン7じゃないと動かない
    npm install -g npm@7 && \
    npm install -g @vue/cli
# EXPOSE 5173
# ポート8080を公開（Vue CLIのデフォルトポート）
EXPOSE 8080
# 1 Vue CLIで開発サーバーを起動する
CMD ["npm", "run", "serve"]

# @          @@          @@          @@          @@          @@          @@          @@          @
# 1
# Vue CLIは古い。現在はViteだが、教材に合わせる
