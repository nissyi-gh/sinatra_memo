# Sinatra Memo App
Sinatraを使用して作成したメモアプリです。
<br>

<img width="320" alt="スクリーンショット 2022-07-04 16 03 36" src="https://user-images.githubusercontent.com/81596063/177102542-9b985633-fb41-4c43-baf7-de65b1645df5.png">

## 起動するまでの手順
Ruby, およびBundlerがインストールされている必要があります。

1. nissyi-gh/developから、自分のリポジトリへ[Fork](https://docs.github.com/ja/get-started/quickstart/fork-a-repo#forking-a-repository)します
2. [git clone](https://docs.github.com/ja/get-started/quickstart/fork-a-repo#cloning-your-forked-repository)します
3. 以降の操作はダウンロードしたディレクトリのルート（app.rbがある階層）で行います。
  - `git checkout develop` でdevelopブランチに移動します。
  - `bundle install` をします。
  - `bundle exec ruby app.rb` を実行します。
  - 終了時は`Ctrl+C`を実行してください。

## 使い方

- メモを作るには必ずタイトルが必要です。
- メモを作成、保存するときにタイトルがない場合はエラーを表示します。
- 作成したメモは隠しファイルの `.memos.json`内にJSON系式で保存しています。
  - `.memos.json`ファイルは自動で生成します。
- 将来的に「ゴミ箱」機能や「ゴミ箱から復元」機能を実装できるようにするため、削除したメモはJSONファイル内に残しています。
- 手動でファイル内を空にすることで完全に削除できますが、復元できなくなりますのでご注意ください。
