## ローカル環境での動作確認方法
　以下の３つを起動させるとローカル環境でも動作を確認できる。
```
# 全て別タブにて
rails s
redis-server
bundle exec sidekiq -q default
```

## herokuの再起動方法
```
# sidekiq
heroku restart worker -a phase-estimate-with-suumo
```
