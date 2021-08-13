class BrowserOperation
  require 'selenium-webdriver'
  # require 'webdrivers'

  SLEEP_TIME = 5

  def valid_suumo_url?(url)
    @driver.get(url)

    begin @driver.find_element(:id, 'js-errorcontents')
    rescue
      true
    else
      quit_driver
      false
    end
  end

  def starting_headless_chrome
    if Rails.env.production?
      Selenium::WebDriver::Chrome.path = ENV.fetch('GOOGLE_CHROME_BIN', nil)
      options = Selenium::WebDriver::Chrome::Options.new(
        prefs: { 'profile.default_content_setting_values.notifications': 2 },
        binary: ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      )
    else
      options = Selenium::WebDriver::Chrome::Options.new
    end
    # heroku上でのメモリ不足対策
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--remote-debugging-port=9222')
    # options.add_argument('window-size=500,500')
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def find_room_name
    @driver.find_element(:class, 'section_h1-header-title').text
  end

  def able_to_aimitu?
    begin @driver.find_element(:id, 'shoplist')
    rescue
      quit_driver
      false
    else
      true
    end
  end

  def get_shop_list
    shop_titles = @driver.find_elements(:class, 'itemcassette-header-ttl').map{|shop| shop.text}
  end

  # 2番目以降の店舗に相見積もりを送るページに遷移する
  def get_to_form_page(shop_index)
    @driver.find_element(:id, "siryouForm_#{shop_index - 1}").click
  end

  # フォームに情報を入力し、送信する
  def send_form(inquiry, name, mail, phone = nil)
    sleep SLEEP_TIME
    reload_if_apper_modal
    sleep SLEEP_TIME
    @driver.find_element(:id, 'item_name_03').location_once_scrolled_into_view
    # その他の問い合わせ（※詳細記入必須）を選択する
    @driver.find_element(:id, 'item_name_03').click
    # フォームが出るまで待機する
    sleep SLEEP_TIME
    # フォームに入力する
    @driver.find_element(:id, 'js-check_list_textarea').send_keys(inquiry)
    sleep SLEEP_TIME
    # 名前を入力する
    @driver.find_element(:id, 'kjs').send_keys(name)
    sleep SLEEP_TIME
    # メールを入力する
    @driver.find_element(:id, 'js-suddest_input').send_keys(mail)
    # メールドメインのプルダウンを消すためにクリックを入れる
    @driver.find_element(:id, 'js-valid_call').click
    sleep SLEEP_TIME
    # 電話番号を入力する
    @driver.find_element(:name, 'telNo').send_keys(phone) unless phone.nil? || phone.blank?
    # 不要なチェックボックスを解除する
    ['auto_reflection', 'morelist_item_01', 'morelist_item_02', 'morelist_item_03'].each do |element_id|
      unclick_unnecessary_checks(element_id)
    end
    # フォーム送信確認画面に遷移する
    @driver.find_element(:class, 'action_inquiry-item').click
    # 確認ページが表示されるまで待つ
    sleep SLEEP_TIME
    # フォームを送信する
    submit_form
  end

  def get_to(url)
    @driver.get(url)
  end

  def unclick_unnecessary_checks(element_id)
    sleep SLEEP_TIME
    begin @driver.find_element(:id, element_id).location_once_scrolled_into_view
    rescue
      p "#{element_id}:存在せず"
    end
    sleep SLEEP_TIME
    begin @driver.find_element(:id, element_id).click
    rescue
      p "#{element_id}:クリックできず"
    end
  end

  def quit_driver
    @driver.quit
  end

  def submit_form
    # ボタンが見えるところまでスクロールする
    @driver.execute_script('window.scroll(0,1000000);')
    sleep SLEEP_TIME
    @driver.find_element(:class, 'actionunit-submit-btn').send_keys(:enter)
  end

  def reload_if_apper_modal
    begin @driver.find_element(:class, '_karte-temp-close__28MX_').click
    rescue
      p "modalなし"
    end
  end
end
