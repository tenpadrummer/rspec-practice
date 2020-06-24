# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# letメソッドは、呼ばれたときに初めてデータを読み込む、遅延読み込みを実現するメソッド。
# beforeブロックの外部で呼ばれるため、セットアップに必要なテストの構造を減らすことができる。

# letは必要に応じてデータを作成する。
# beforeはテストデータをセットアップする際インスタンス変数に格納する。

# subjectメソッドは、テストの対象物(subject)を宣言し、そのあとに続くexample内で何度でも再利用が可能。゙

# is_expectedメソットは、expect(something)と比較しワンライナーのテストを書くことができる。

# specifyはitのエイリアズ

RSpec.describe Task, type: :model do
  # letを使って必要となるプロジェクトを作成する。
  # プロジェクトが 作成されるのはプロジェクトが必要になるテストのみ
  let(:project) { FactoryBot.create(:project) }

  # プロジェクトと名前があれば有効な状態であること
  it "is valid with a project and name" do
      # projectがここで呼ばれるため、letで作られた値が呼びだされる。
      task = Task.new(
        project: project,
        name: "Test task",
      )
    expect(task).to be_valid
    # このタスクが終了すると、letで作成゚されたプロジェクトが取り除かれる。
  end


  # プロジェクトがなければ無効な状態であること
  # 本当にプロジェクトがいらないテストのため、゙プ゚ロジェクトは作成されない
  it "is invalid without a project" do
    task = Task.new(project: nil)
    task.valid?
    expect(task.errors[:project]).to include("must exist")
  end

  # 名前がなければ無効な状態であること
  # 元々プロジェクトがいらないテストのため、゙プ゚ロジェクトは作成されない
  it "is invalid without a name" do
    task = Task.new(name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end
end
