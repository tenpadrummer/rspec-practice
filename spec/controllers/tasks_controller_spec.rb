# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# taskコントローラには、HTML通信の他にJSON形式もあるため、
# JSONの出力をテストする
RSpec.describe TasksController, type: :controller do

  include_context "project setup"

  describe "#show" do
    # JSON 形式でレスポンスを返すこと
    it "responds with JSON formatted output" do
      sign_in user
      # ここでのリクエストにJSON形式を指定
      get :show, format: :json,
        params: { project_id: project.id, id: task.id }
      expect(response).to have_content_type :json
    end
  end

  describe "#create" do
    # JSON 形式でレスポンスを返すこと
    it "responds with JSON formatted output" do
      # taskを生成
      new_task = { name: "New test task" }
      sign_in user
      # showと異なる点は、new_taskを生成し、それをキーtaskのvalueがtaskのidではなく、new_taskということで、taskのパラメータも一緒に送信
      post :create, format: :json, params: { project_id: project.id, task: new_task }
      # application/jsonのContent-Typeでレスポンスを返すか検証
      expect(response).to have_content_type :json
    end

    # 新しいタスクをプロジェクトに追加すること
    it "adds a new task to the project" do
      new_task = { name: "New test task" }
      sign_in user
      expect {
        # format: :jsonとJSON形式で送ることを指定
        post :create, format: :json, params: { project_id: project.id, task: new_task }
      }.to change(project.tasks, :count).by(1)
      #新しくタスクが生成されたことで、taskの数に増減があるか検証
    end

    # 認証を要求すること
    it "requires authentication" do
      new_task = { name: "New test task" }
      # ここではあえてログインしない
      expect {
        post :create, format: :json, params: { project_id: project.id, task: new_task }
      }.to_not change(project.tasks, :count)
      # to_notなので、期待していることは「createアクションでタスクを送信、そのタスクの数が変わっていないということ」を検証する
      expect(response).to_not be_success
      # ユーザーがログインしていないので生成できない
      # タスクの数が変わらなかったので be_success
    end
  end
end
