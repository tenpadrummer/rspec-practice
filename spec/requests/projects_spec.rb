# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'


RSpec.describe "Projects", type: :request do
  # 認証済みのユーザーとして
  context "as an authenticated user" do

    before do
      @user = FactoryBot.create(:user)
    end

    # 有効な属性値の場合
    context "with valid attributes" do
      # プロジェクトを追加できること
      it "adds a project" do
        project_params =
        # attributes_forはハッシュを作る。
        # buildで生成するオブジェクトをテストするのではなく、
        # attributes_forでパラメータをテストする。
        FactoryBot.attributes_for(:project)
        # @userをログインした状態にする
        sign_in @user
        # 具体的なルーティング名を指定しPOSTリクエストが送られた時の検証を期待する。これがコントローラスペックとの違い
        expect {
          post projects_path, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end
    # 無効な属性値の場合
    context "with invalid attributes" do
      # プロジェクトを追加できないこと
      it "does not add a project" do
        # 上記の逆を検証する、したがって、〜でないこととなるため、to_not
        project_params = FactoryBot.attributes_for(:project, :invalid)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params }
        }.to_not change(@user.projects, :count)
      end
    end
  end
end
