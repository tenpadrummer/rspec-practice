# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

RSpec.describe "Home page", type: :request do
  # 正常なレスポンスを返すこと
  it "responds successfully" do
    # トップページにHTTPリクエストGETで送信
    get root_path
    # リクエストが成功するか確認
    expect(response).to be_success
    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response).to have_http_status "200"
  end
end
