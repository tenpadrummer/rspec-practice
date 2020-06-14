# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

#be_successマッチャを使用し、予期していることが成功するか検証
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

  describe "#show" do
    # 認可されたユーザーとして
    # ログインしたユーザーがプロジェクトのオーナー
    context "as an authorized user" do
      #showアクションを動かす前に、FactroyBotでユーザーとプロジェクトを作成
      before do
        @user = FactoryBot.create(:user)
        # このプロジェクトはオーナーのものとして生成
        @project = FactoryBot.create(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        # プロジェクトの id をコントローラアクションの param 値として渡さなければいけない
        get :show, params: {id: @project.id}
        expect(response).to be_success
      end
    end

    # 認可されていないユーザーとして
    # ログインしていないユーザーがプロジェクトのオーナー
    context "as an unauthorized user" do
      before do
        # こちらは認可されているユーザーとして生成
        @user = FactoryBot.create(:user)
        # こちらは認可されていないユーザーとして生成
        other_user = FactoryBot.create(:user)
        # このプロジェクトはother_userのものとして生成
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        # プロジェクトの id をコントローラアクションの param 値として渡さなければいけない
        get :show, params: {id: @project.id}
        # redirect_toマッチャでルートへのprefixへ移動するか検証
        expect(response).to redirect_to root_path
      end
    end
  end
end
