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

# ユーザーは同じ名前のプロジェクトを複数持つことができないが、ユーザーが異なれば同じ名前のプロジェクトがあっても構わない、というテスト。
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

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

  # たくさんのメモが付いていること
  it "can have many notes" do
    # FactoryBotを使用しデータを作成
    # トレイトでセットした:with_notesをコールバックし、テストをパスさせる
    project = FactoryBot.create(:project, :with_notes)
    # プロジェクトにあるメモが５個あるか（lengthが == 5か）検証する
    expect(project.notes.length).to eq 5
  end
end
