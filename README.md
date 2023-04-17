# SUUMO掲載物件の相見積もりが取れるサイト
![image](https://user-images.githubusercontent.com/22629857/232632057-b3185b88-f6ee-4da3-89f6-d7eeb2a978df.png)

## 概要
　SUUMOに掲載されている賃貸物件のページにおいて、その物件を取り扱う不動産仲介業者に対して、同一の見積もり依頼メッセージを送信できるサイトです。

## 動きの概要
- SUUMOに掲載されている賃貸物件の個別ページのURLをフォームに入力する。（https://suumo.jp/chintai/以下のページ）
- seleniumでその物件を取り扱う不動産仲介業者の一覧を取得して、サイトに表示する。
- 見積もり依頼メッセージ（SUUMOの仕様で100文字以下）を入力し、それを送信する不動産仲介業者を選択する。
- sidekiqのworkerにキューが飛び、worker内でseleniumを使ってSUUMOのページにアクセスし、見積もり依頼メッセージを、SUUMOのフォームから送信する。

## 運用当時のメモ
- 運用当時はherokuのサーバーを使ってサイトを運用していた。
- heroku有料化に伴い運用を停止した。

## 開発作業用メモ
### ローカル環境での動作確認方法
　以下の３つを起動させるとローカル環境でも動作を確認できる。
```
# 全て別タブにて
rails s
redis-server
bundle exec sidekiq -q default
```

### herokuの再起動方法
　管理画面からでは再起動できないやつの対応メモ（workerなど
```
# sidekiq
heroku restart worker -a インスタンス(dyno）名
```
