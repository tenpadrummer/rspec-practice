# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# toは「～であること」を期待
# not_to / to_notは「～でないこと」を期待

# マッチャについて(matcher)
# マッチャ（matcher）は「期待値と実際の値を比較して、一致した（もしくは一致しなかった）という結果を返すオブジェクト]
# be_validマッチャは、期待値は有効かどうか検証
# eqマッチャは、期待値と実際の値が「等しい」かどうかを検証
# includeマッチャは、「～が含まれていること」を検証。ハッシュや文字列に対しても使用可能。
# be_xxx (predicateマッチャ)は、述語のように使用可能
# be_emptyマッチャの場合、期待値が空かどうかを検証

# 期待する結果をまとめて記述(describe)。
# example(itで始まる1行)一つにつき、結果を一つだけ期待している。
# Projectという名前のモデルのテストをここに書くことを示している。
RSpec.describe Project, type: :model do

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  # 両方のプロジェクトを割り当てられた一人のユーザーがいるというexample。
  it "does not allow duplicate project names per user" do
    # 一人のユーザーを生成
    user = User.create(
      first_name:   "Joe",
      last_name:    "Tester",
      email:        "joetester@example.com",
      password:     "dottle-nouveau-pavilion-tights-furze",
    )

    # 先ほど生成したユーザーのプロジェクトを生成する。
    user.projects.create(
      name: "Test Project",
    )

    # もう一つ同じユーザーがプロジェクトを生成し、new_projectに代入する。
    new_project = user.projects.build(
      name: "Test Project",
    )

    # new_projectに対して、有効かどうか検証。
    # この場合createしたprojectとnew_projectの名前(値)がすでに存在するかどうかをチェック。
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  # 二つの別々のプロジェクトに同じ名前が割り当てられ、それらが別々のユーザーに属しているexample
  it "allows two users to share a project name" do

    # 一人目のユーザーを生成
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )

    # 一人目のユーザーのプロジェクトを生成する。
    user.projects.create(
      name: "Test Project",
    )

    # 二人目のユーザーを生成
    other_user = User.create(
      first_name: "Jane",
      last_name:  "Tester",
      email:      "janetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )

    # 一人目のユーザーのプロジェクトを生成する。
    other_project = other_user.projects.build(
      name: "Test Project",
    )

    # be_valid?でモデルが有効な状態を理解しているかいないかを検証。
    # 今回の場合、other_projectの状態、つまりnameがnil,重複していないか検証。
    expect(other_project).to be_valid
  end


  describe "late status" do
    # be_lateマッチャは late または late? という名前の属性やメソッドが存在し、それが真偽値を返すようになっていれば使用可能。

    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project_due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project_due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
