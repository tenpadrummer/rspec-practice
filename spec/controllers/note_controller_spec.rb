# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# モック(mock)は本物のオブジェクトのふりをするオブジェクト
# モックはこれまでファクトリなどを使って作成したオブジェクトの代役となる

# スタブ(stub)はオブジェクトのメソッドをオーバーライドし、事前に決められた値を返す。すなわち、呼び出されるとテスト用に本物の結果を返すダミーメソッド。
# スタブをよく使うのは,メソッドのデフォルト機能をオーバーライドするケース.

# コントローラのテストでモックやスタブが使われることが多い。
# データベースにまったくアクセスせずにコントローラのメソッドをテストする。
RSpec.describe NotesController, type: :controller do

  # データベースを検索するかわりにモックのprojectを使用

  # letを利用しuserとprojectを遅延定義

  # モック化されたuserは通常のテストダブルを使用
  let(:user) { double("user") }
  # モック化されたprojectは、 ownerとidの属性を使うので、検証機能付きのテストダブルを使用
  let(:project) { instance_double("Project", owner: user, id: "123") }

  before do
    # 最初にDeviseが用意してくれるauthenticate!メソッドをスタブ化
    allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
    # 最初にDeviseが用意してくれるcurrent_userもスタブ化
    allow(controller).to receive(:current_user).and_return(user)
    # Active Recordが提供しているProject.findメソッドをスタブ化
    allow(Project).to receive(:find).with("123").and_return(project)
  end

  # 上記のコードにより、Project.find(123)がテストコード内のどこかで呼ばれても、本物のプロジェクトオブジェクトではなくテストダブルのprojectが代わりをになってくれる。

  describe "#index" do
    # 入力されたキーワードでメモを検索すること　projectに関連する noteが持つsearchスコープが呼ばれる
    it "searches notes by the provided keyword" do
      # receive_message_chainを使用し、project.notes.searchを参照
      expect(project).to receive_message_chain(:notes, :search).with("rotate tires")
      get :index,
      params: {project_id: project.id, term: "rotate tires"}
    end
  end
end
