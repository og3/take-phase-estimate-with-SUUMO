class PhaseEstimateController < ApplicationController
  before_action :authenticate_user!, only: [:check_url, :send_aimitumori, :result]

  @@result_hash = {}

  def input_url
  end

  def check_url
    # redirect_to input_url_path, alert: "サイトの利用にはログインが必要です。" and return if authenticate_user!
    redirect_to input_url_path, alert: "SUUMOの賃貸物件ページのURLではありません。" and return unless params[:url].include?("https://suumo.jp/chintai")

    browser_operation = BrowserOperation.new
    browser_operation.starting_headless_chrome

    redirect_to input_url_path, alert: "urlにアクセスできませんでした。" and return unless browser_operation.valid_suumo_url?(params[:url])
    redirect_to input_url_path, alert: "本物件は取扱店舗が1件しかないため相見積もりは取れません" and return unless browser_operation.able_to_aimitu?

    @@result_hash[:room_name] = browser_operation.find_room_name
    @@result_hash[:shop_list] = browser_operation.get_shop_list
    @@result_hash[:url] = params[:url]

    browser_operation.quit_driver

    redirect_to result_path
  end

  # URLの結果を確認する
  def result
    @result = @@result_hash
  end

  # 相見積もりを送る
  def send_aimitumori
    check_aimitumori_params(params)
    SendAimitumoriJob.perform_later(params.permit!)

    redirect_to success_send_aimitumori_path
  end

  def success_send_aimitumori
  end

  private

  def check_aimitumori_params(params)
    unless params[:shop_list].present? && params[:inquiry].present? && params[:name].present? && params[:mail].present?
      redirect_to result_path, alert: "「必須」の項目は全て入力してください。"
    end

    unless params[:shop_list].values.include?("1")
      redirect_to result_path, alert: "「見積もり対象店舗」は最低１つ以上チェックしてください。"
    end

    unless params[:inquiry].size <= 100
      redirect_to result_path, alert: "「問い合わせ内容」は100文字以下で入力してください。"
    end

    unless params[:phone].size <= 11
      redirect_to result_path, alert: "「電話番号」の文字数が不正です。"
    end
  end

end
