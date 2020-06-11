require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Projects
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.generators do |g|

      # RSpec 用のスペックファイルも一緒に作ってもらうよう Rails を設定
      g.test_framework :rspec,
        fixtures: false, # テストデータベースにレコードを作成するファイルの作成をスキップ
        view_specs: false, # ビュースペックを作成しない
        helper_specs: false, # ヘルパーファイル用のスペックを作成しない
        routing_specs: false # routes.rb 用のスペックファイルの作成を省略
      end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
