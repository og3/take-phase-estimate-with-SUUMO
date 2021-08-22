class SendAimitumoriJob < ApplicationJob
  queue_as :default
  # エラーが出たらリトライさせない
  discard_on Selenium::WebDriver::Error::NoSuchWindowError
  discard_on Selenium::WebDriver::Error::ElementNotInteractableError

  def perform(params, email)
    target_shop_datas = target_shop_datas(params[:shop_list])
    mitumori_log = email.mitumori_logs.find{|log| log.url == params[:url]}

    browser_operation = BrowserOperation.new
    browser_operation.starting_headless_chrome
    browser_operation.get_to(params[:url])

    target_shop_datas.each do |target_shop_data|
      next if target_shop_data[:send_flag] == "0"
      browser_operation.get_to_form_page(target_shop_data[:index]) unless target_shop_data[:index] == 0

      browser_operation.send_form(params[:inquiry], params[:name], params[:mail], params[:phone])
      browser_operation.get_to(params[:url])
    end

    browser_operation.quit_driver
    mitumori_log.update(status: true)
  end

  private

  def target_shop_datas(shop_list)
    target_shop_datas = []

    shop_list.each_with_index do |shop, i|
      shop_data = {}
      shop_data[:shop_name] = shop[0]
      shop_data[:send_flag] = shop[1]
      shop_data[:index] = i
      target_shop_datas << shop_data
    end

    target_shop_datas
  end
end
