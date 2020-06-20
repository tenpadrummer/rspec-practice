# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# 適切なAPIは、HTTPのレスポンスのステータスコードと実際のデータを含んだレスポンスを返すかをテストするものがリクエストスペック。
# リクエストスペックでは、コントローラのレスポンスをテストする際に使ったHTTP動詞に対応するメソッド(get、post、delete、patch)を使用する。
# 200: OK - リクエスト成功.
# 401: Unauthorized - 認証失敗。
# 403: Forbidden - 禁止。
# 404: Not Found - 未検出。
# リクエストスペックはコントローラに結びつく必要はない。
# テストしたいルーティング名をちゃんと指定しているか確認する必要あり。
# ここでは1人のユーザーと2件のプロジェクトを作成している。
# 一方のプロジェクトは先ほどのユーザーがオーナー゙、もう一つのプロジェクトは別のユーザーがオーナー。

describe "Projects API", type: :request do

  # 1件のプロジェクトを読み出すこと
  it "loads a project" do
    # userをファクトリで生成する
    user = FactoryBot.create(:user)
    # ファクトリでnameが"Sample Projects"のprojectを作成する
    FactoryBot.create(:project,
      name: "Sample Projects"
    )
    # ファクトリでnameが"Second Sample Project"のprojectを作成する
    FactoryBot.create(:project,
      name: "Second Sample Project",
      owner: user
    )
    # このAPIでユーザーのメールアドレスとサインイン時のトークンが必要になる。HTTPリクエストGETのパラメータにそれを含めている。
    # ここはindexアクション（ルーティング）のテスト
    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response).to have_http_status(:success)
    #　
    json = JSON.parse(response.body)
    # jsonのlengthが1に等しいかどうか期待する。
    # つまりこのユーザーがオーナーになっているのは1件だけなので成功する。
    expect(json.length).to eq 1

    # このAPIでユーザーのメールアドレスとサインイン時のトークンが必要になる。HTTPリクエストGETのパラメータにそれを含めている。
    # ここからshowアクション（ルーティング）のテスト
    project_id = json[0]["id"]
    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    # jsonのnameが"Second Sample Project"と等しいかどうか期待する。
    expect(json["name"]).to eq "Second Sample Project"
  end

  it "create a project" do
    user = FactoryBot.create(:user)
    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      # ここではユーザーのメールアドレスとサインイン時のトークン、そしてそのユーザーのプロジェクトが必要になる。HTTPリクエストGETのパラメータにそれを含めている。
      # ここはcreateアクション（ルーティング）のテスト
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
      # ユーザーのプロジェクトの数が１件増えることを期待する。
    }.to change(user.projects, :count).by(1)
    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response).to have_http_status(:success)
  end
end
