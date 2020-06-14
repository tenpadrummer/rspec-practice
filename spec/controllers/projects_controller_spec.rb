# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

#have_status_httpマッチャを使用し、どんなレスポンスを返すか検証
#redirect_toマッチャを使用し、どのページに移動しているか検証

RSpec.describe ProjectsController, type: :controller do
  describe "index" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      # exampleを実行する前にbeforeブロックでユーザーを作成しておく
      before do
        @user = FactoryBot.create(:user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        # ログイン状態をシミュレートするためにsign_inヘルパー
        sign_in @user
        get :index
        expect(response).to be_success
        # indexアクションには認証済みのユーザーでアクセスしていることになる
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        # ログイン状態をシミュレートするために sign_in ヘルパー
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
        # indexアクションには認証済みのユーザーでアクセスしていることになる
      end
    end

    # ゲストとして
    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 request" do
        get :index
        expect(response).to have_http_status "302"
      end

      # ゲストユーザーなら、サインイン画面にリダイレクトすること
        it "redirects to the sign in page" do
        get :index
        # 結果がゲストユーザーであることと検証できれば、"/users/sign_in"へリダイレクト
        # projects_controllerの  before_action :project_owner?, except: [:index, :new, :create]と同じ動き
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
