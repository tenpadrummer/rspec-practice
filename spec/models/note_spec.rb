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
# Noteという名前のモデルのテストをここに書くことを示している。
RSpec.describe Note, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:project) {FactoryBot.create(:project, owner: user)}

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    # noteを生成するが、@userと@projectはbeforeブロックで生成されている。
    note = Note.new(
      message: "This is a sample note.",
      user: user,
      project: project,
    )
    # note(ユーザー、プロジェクト、メッセージ)は有効かどうか検証する。
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without a message" do
    # noteにmessageがnilで代入する。
    note = Note.new(message: nil)
    # noteの値をチェック
    note.valid?
    # noteにメッセージがなければテストをパス。"can't be blank"を返す。
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do

    # letとは異なり、let!は遅延読み込みされない。
    # let!はブロックを即座に実行

    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note.",
      )
    }
    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note.",
      )
    }
    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven.",
      )
    }

    # 一致するデータが見つかるとき
    context "when a match is found" do
      # 検索文字列に一致するメモを返すexample
      it "returns notes that match the search term" do
        # @note1, @note3のmessageの中に"first"が含まれているか検索。
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    # 一致するデータが1件も見つからないときのexample
    context "when no match is found" do
    # 空のコレクションを返すこと
      it "returns an empty collection" do
        # @note1, @note2, @note3のmessageの中に"message"が含まれているか検索。
        # 含まれておらず、空だったらテストをパスする。
        expect(Note.search("message")).to be_empty
      end
    end
    # 一致するデータが1件も見つからないとき
    context "when no match is found" do
      # 空のコレクションを返すこと

      it "returns an empty collection" do
        note1
        note2
        note3
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
end



# describe、context、before、afterを使ってDRYにする
# describeブロックではクラスやシステムの機能に関するアウトラインを記述
# contextブロックでは特定の状態に関するアウトラインを記述
# beforeブロックの中に書かれたコードは内側の各テストが実行される前に実行。
# また、beforeブロックはdescribeやcontextブロックによってスコープが限定される。
# before(:each)はdescribeまたはcontextブロック内の各(each)テストの前に実行
# before(:all)はdescribeまたはcontextブロック内の全(all)テストの前に一回だけ実行
# before(:suite)はテストスイート全体の全ファイルを実行する前に実行
# afterブロック

# -------------------------------------------------------
# decribeやcontextを使用しないとこのように書く

  # # 検索文字列に一致するメモを返すこと
  # it "returns notes that match the search term" do
  #   #　ユーザーを生成する
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name:  "Tester",
  #     email:      "joetester@example.com",
  #     password:   "dottle-nouveau-pavilion-tights-furze",
  #   )

  #   # projectを生成する
  #   project = user.projects.create(
  #     name: "Test Project",
  #   )

  #   # 3つのnoteを作成する。
  #   note1 = project.notes.create(
  #     message: "This is the first note.",
  #     user: user,
  #   )
  #   note2 = project.notes.create(
  #     message: "This is the second note.",
  #     user: user,
  #   )
  #   note3 = project.notes.create(
  #     message: "First, preheat the oven.",
  #     user: user,
  #   )

  #   # Note1,2,3のうち1,3より、"first"とmessageの中に一致するものがあるかsearchし検証。
  #   expect(Note.search("first")).to include(note1, note3)
  #   # Note2より、"first"とmessageの中に一致するものがあるかsearchし検証するが、to_notのため一致しないければテストを通す。
  #   expect(Note.search("first")).to_not include(note2)
  # end

  # # 結果が返ってこない文字列で検索したときもexampleで用意し検証する。
  # # 検索結果が1件も見つからなければ空を返す。
  # it "returns an empty collection when no results are found" do
  #   #ユーザーを生成する
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name:  "Tester",
  #     email:      "joetester@example.com",
  #     password:   "dottle-nouveau-pavilion-tights-furze",
  #   )
  #   # プロジェクトを生成する
  #   project = user.projects.create(
  #     name: "Test Project",
  #   )
  #   # noteを生成する
  #   note1 = project.notes.create(
  #     message: "This is the first note.",
  #     user: user,
  #   )
  #   note2 = project.notes.create(
  #     message: "This is the second note.",
  #     user: user,
  #   )
  #   note3 = project.notes.create(
  #     message: "First, preheat the oven.",
  #     user: user,
  #   )

  #   # note1,2,3より、"message"の文字列がmessageに存在するか検索し検証。
  #   # 検証の際は配列をチェック。今回の場合空（存在しない）のため、be_emptyを返す。
  #   expect(Note.search("message")).to be_empty
  # end
