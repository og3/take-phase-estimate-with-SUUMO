class PhaseEstimateController < ApplicationController
  before_action :authenticate_user!, only: [:check_url, :send_aimitumori, :result]
  skip_before_action :verify_authenticity_token

  @@result_hash = {}

  def input_url
  end

  def check_url
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
    redirect_to input_url_path, alert: "同じ物件への見積もり依頼の一括送信は1度のみ可能です。" and return if sent_before?(current_user, params[:url])

    check_aimitumori_params(params)
    create_aimitumori_log(current_user.id, params)
    SendAimitumoriJob.perform_later(params.permit!, current_user)

    redirect_to input_url_path, notice: "見積もり依頼の送信を受け付けました。「マイページ」にて進捗状況が確認できます。"
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

  def sent_before?(user, url)
    user.aimitumori_logs.select{|log| log.url == url}.present?
  end

  def create_aimitumori_log(user_id, params)
    AimitumoriLog.create(user_id: user_id, bukken_name: params[:room_name], url: params[:url], shop_names: params[:shop_list])
  end
end
