# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  # indexアクションのテスト
  describe "index" do

    # 正常にレスポンスを返すこと
    it "responds successfully" do
      # HTTP レスポンスコード
      get :index
      # be_successはレスポンスステータスが成功(200レスポンス)かそれ以外(たとえば500エラー)であるかをチェック
      expect(response).to be_success
    end

    #200レスポンスを返すこと
    it"returnsa200response"do
      get :index
      expect(response).to have_http_status "200"
    end
  end
end
