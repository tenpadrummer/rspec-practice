# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  #indexアクションのテスト
  # HTTPのGETリクエストを使用
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
        # be_successマッチャを使用し、予期していることが成功するか検証
        expect(response).to be_success
        # indexアクションには認証済みのユーザーでアクセスしていることになる
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        # ログイン状態をシミュレートするために sign_in ヘルパー
        sign_in @user
        get :index
        # have_status_httpマッチャを使用し、どんなレスポンスを返すか検証
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
        # redirect_toマッチャを使用し、どのページに移動しているか検証
        # projects_controllerの  before_action :project_owner?, except: [:index, :new, :create]と同じ動き
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  # showアクションのテスト
  # HTTPのGETリクエストを使用
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

  # createアクションのテスト
  # HTTPのPOSTリクエストを使用
  describe "#create" do
    # 認証済みのユーザーとして
    # ログイン済みのユーザーであれば新しいプロジェクトが作成できるか検証していく
    context "as an authenticated user" do

      before do
        @user = FactoryBot.create(:user)
      end

      # プロジェクトを追加できること
      it "add a project" do
        # attributes_forでファクトリからテスト用の属性値をハッシュとして作成。
        # buildとの違いは、モデルオブジェクトではなく、ハッシュであるということ
        # パラメータとして値を渡す場合、ハッシュを使って渡すことが目的で、
        project_params = FactoryBot.attributes_for(:project)
        # p project_params
        sign_in @user
        # ここで期待していることは、POSTメソッドで渡すparamsにPOSTキー、
        # そのキーのValueをattributes_forの返り値を渡すどうなるかということ
        expect {
          # paramsのprojectに渡されるものは、ハッシュ
          post :create, params: {project: project_params}
          # changeマッチャは、状態が変わったことだけを検証
          # ログイン済みユーザーのプロジェクトが増減したか検証する (by(増減する値の数))
        }.to change(@user.projects, :count).by(1)
      end
    end

    # ゲストとして
    # ゲストであればアクションへのアクセスを拒否されることを検証していく
    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        # attributes_forでファクトリからテスト用の属性値をハッシュとして作成。
        project_params = FactoryBot.attributes_for(:project)
        # HTTPリクエストPOSTで、ファクトリで生成したハッシュのproject_paramsを渡す
        post :create, params: { project: project_params }
        # しかしこのプロジェクトはログイン済みユーザーのものではないため、302を返すか期待する
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        # ゲストであればアクションへのアクセスを拒否されるはず
        # 拒否されたらサインイン画面にリダイレクトをするか検証
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  # updateアクションのテスト
  # HTTPのPATCHリクエストを使用
  describe "#update" do
    # 認可されたユーザーとして
    # ユーザーが自分のプロジェクトを編集できるか検証
    context "as an authorized user" do

      before do
        @user = FactoryBot.create(:user)
        # このプロジェクトはオーナーのものとして生成
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを更新できること、既存のプロジェクトの更新が成功したかどうかを検証
      it "updates a project" do
        # attributes_forを使用し、ファクトリで生成するデータをハッシュとして作成、nameのみオーバーライド
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        # 元のプロジェクトのidと、新しいプロジェクトの属性値をparamsとして一緒にPATCHリクエストで送信
        patch :update, params: { id: @project.id, project: project_params }
        # テストで使った@projectの新しい値(nameが"New Project Name"かどうか)を検証
        # reloadメソッドでデータベース上の値を読み込む
        expect(@project.reload.name).to eq "New Project Name"
        # メモリに保存された値が再利用されてしまい、値の変更が反映されないことを防ぐため、reloadする
      end
    end

    # 認可されていないユーザーとして
    context " as an unauthorized user " do
      # 認可されていないユーザーがプロジェクトを更新しようとしたときのテスト
      # その際利用するデータを作成しておく
      before do
        # 認可されたユーザー
        @user = FactoryBot.create(:user)
        # 認可されていないユーザー
        other_user = FactoryBot.create(:user)
        # この@projectはオーナーが認可されていないユーザー
        @project = FactoryBot.create(:project, owner: other_user, name: "Same Old Name")
      end

      # プロジェクトを更新できないこと
      it "does not update the project" do
        # attributes_forを使用し、ファクトリで生成するデータをハッシュとして作成、nameのみオーバーライド
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in @user
        # 元のプロジェクトのidと、新しいプロジェクトの属性値をparamsとして一緒にPATCHリクエストで送信
        patch :update, params: { id: @project.id, project: project_params }
        # 認可されていないユーザーが他のユーザーのプロジェクトにアクセスしようとしている
        # @projectのユーザーとsign_inしているユーザーが異なるため、更新できない
        # nameが"Same Old Name"と"New Name"が等しいか検証 = 等しくない
        # つまり、プロジェクトの名前が変わっていないことを最初に検証している
        expect(@project.reload.name).to eq "Same Old Name"
      end

      # ダッシュボードへリダイレクトすること
      it "redirects to the dashboard" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        # 流れは上記と同じ。更新はできない
        patch :update, params: { id: @project.id, project: project_params }
        # 認可されていないユーザーがダッシュボード画面にリダイレクトされることを検証
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    context "as a guest" do
      # シンプルにユーザーは生成しない
      before do
        @project = FactoryBot.create(:project)
      end

      # 302レスポンスを返すこと
      # ゲストはプロジェクトを更新できない
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  # destroyアクションのテスト
  # HTTPのdeleteリクエストを使用
  describe "#destroy" do

    # 認可されたユーザーとして
    context "as an authorized user" do

      before do
        @user = FactoryBot.create(:user)
        # @projectは@userのものとして生成し、代入
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを削除できること
      it "deletes a project" do
        sign_in @user
        # 認可済みユーザーが、プロジェクトをdestoryできるか期待
        # 認可済みユーザーのプロジェクト数が増減したか検証
        expect { delete :destroy, params: { id: @project.id }}.to change(@user.projects, :count).by(-1)
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do

      before do
        @user = FactoryBot.create(:user)
        # other_userは認可されていないユーザーとして扱い、other_userに代入
        other_user = FactoryBot.create(:user)
        # @projectはother_userのものとして生成しておく
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        sign_in @user
        # 認可済みユーザーは@userであり、このプロジェクトはother_userのものなので削除できない
        # 認可されていないユーザーのプロジェクト数が増減したか検証
        expect {delete :destroy, params: { id: @project.id }}.to_not change(Project, :count)
      end

      # ダッシュボードにリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    # 上記updateのexampleと検証がほぼ同じ
    context "as a guest" do

      before do
        @project = FactoryBot.create(:project)
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        # ファクトリで生成したProjectの数が増減(すなわち-1)されたかを検証
        expect { delete :destroy, params: { id: @project.id }}.to_not change(Project, :count)
      end
    end
  end
end