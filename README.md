# Zaimデータ取得アプリ

RailsでZaimの家計簿データを取得する。

## アプリケーションのURL
https://this-app-host

## 実装した仕様

実装した仕様と機能を実装したページを以下に示す。

* 「ログイン」より、ZaimのOAuth認証を行い、Zaim APIを実行可能な状態にする
* 「ログアウト」より、ログアウトできる
* 「HOME」の「Zaim連携」の「ダウンロード」より、Zaimの各種データをJSON形式でpublic/zaimdataディレクトリにダウンロードできる
* 「HOME」の「Zaim連携」の「インポート」より、Zaimの各種データをDBに取り込むことができる
* 「履歴一覧」より、DBに取り込み済みのデータの一覧を参照できる
* 「グラフ」より、DBに取り込み済みのデータをグラフで可視化できる
* /money.jsonより、DBに取り込み済みのデータをJSON形式で取得できる

## セットアップ

### Ruby version
2.2.2

### gemインストール
````
gem install bundle
bundle install
````

### DBマイグレーション
````
bundle exec rake db:migrate
````
### 環境変数

Zaim APIを使用するため、以下にログインし「新しいアプリケーションを追加」する。

https://dev.zaim.net/

環境変数に上で取得したConsumer KeyとConsumer Secretをセットする。
また、OAuth認証後のコールバックURLに/callbackを指定する。

$RAILS_ROOT/.env
````
CONSUMER_KEY='Zaim APIのConsumer Key'
CONSUMER_SECRET='Zaim APIのConsumer Secret'
CALLBACK_URL='http[s]://this-app-host/callback'
````
