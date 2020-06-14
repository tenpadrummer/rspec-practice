# spec/support/capybara.rb という新しいファイルを作成
# rails_helper.rbのDir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }に関連して、
# RSpec関連の設定ファイルをspec/supportディレクトリに配置することができる。

# Capybara.javascript_driver = :selenium_chrome_headless

require'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist