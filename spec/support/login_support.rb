# DRYのため、サポートモジュールを用意する。
# それぞれのスペックに書いていたモジュールを切り取り、こちらに記載。
# コードの重複を防げるため、フィーチャスペックでよく利用される。

# sign_inのメソッドをmoduleとして定義
module LoginSupport
  def sign_in_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end

# moduleの定義のあとには、RSpecの設定
# RSpec.configureを使って新しく作ったモジュールをincludeする
# 必ずしも必要ではないが、ここでは定義
RSpec.configure do |config|
  config.include LoginSupport
end
