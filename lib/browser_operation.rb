class BrowserOperation
  require 'selenium-webdriver'
  require 'webdrivers'

  SLEEP_TIME = 10

  def initialize
  end

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
    # TODO:デバッグモードで起動したら通常モードで起動するようにしたい。
    # options.add_argument('--headless')
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

  def login_to_rakuten_card_site
    @driver.get('https://www.rakuten-card.co.jp/e-navi/index.xhtml')

    @driver.find_element(:id, 'u').send_keys(@rakuten_card_user_id)
    @driver.find_element(:id, 'p').send_keys(@rakuten_card_password)
    @driver.find_element(:id, 'loginButton').send_keys(:enter)

    sleep SLEEP_TIME
  end

  def get_to_click_point_page
    @driver.get('https://www.rakuten-card.co.jp/e-navi/members/point/click-point/index.xhtml?l-id=enavi_all_glonavi_clickpoint_new')
    sleep SLEEP_TIME
  end

  def click_ad
    current_window = @driver.window_handles.first
    bnrbox_elements_count = @driver.find_elements(:class, 'bnrBox').count
    bnrbox_elements_count.times do |time|
      @driver.find_elements(:class, 'bnrBox')[time].find_element(class: 'bnrBoxInner').click
      sleep SLEEP_TIME
      @driver.switch_to.window(current_window)
      sleep SLEEP_TIME
    end
  end

  def quit_driver
    @driver.quit
  end
end
