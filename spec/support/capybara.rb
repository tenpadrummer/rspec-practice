# spec/support/capybara.rb という新しいファイルを作成
# rails_helper.rbのDir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }に関連して、
# RSpec関連の設定ファイルをspec/supportディレクトリに配置することができる。


# ヘッドレスドライバを使う

# 1.selenium-webdriver と chromedriver-helperをgem install
# Capybara.javascript_driver = :selenium_chrome_headless

# 2.brewでPhantomJSをインストール、gemのpoltergesitをインストール
require'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Capybaraでボタンが現れるまでの時間設定
Capybara.default_max_wait_time = 15