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

  # 検索文字列に一致するメモを返すこと
  it "returns notes that match the search term" do
    #　ユーザーを生成する
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )

    # projectを生成する
    project = user.projects.create(
      name: "Test Project",
    )

    # 3つのnoteを作成する。
    note1 = project.notes.create(
      message: "This is the first note.",
      user: user,
    )
    note2 = project.notes.create(
      message: "This is the second note.",
      user: user,
    )
    note3 = project.notes.create(
      message: "First, preheat the oven.",
      user: user,
    )

    # Note1,2,3のうち1,3より、"first"とmessageの中に一致するものがあるかsearchし検証。
    expect(Note.search("first")).to include(note1, note3)
    # Note2より、"first"とmessageの中に一致するものがあるかsearchし検証するが、to_notのため一致しないければテストを通す。
    expect(Note.search("first")).to_not include(note2)
  end

  # 結果が返ってこない文字列で検索したときもexampleで用意し検証する。
  # 検索結果が1件も見つからなければ空を返す。
  it "returns an empty collection when no results are found" do
    #ユーザーを生成する
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    # プロジェクトを生成する
    project = user.projects.create(
      name: "Test Project",
    )
    # noteを生成する
    note1 = project.notes.create(
      message: "This is the first note.",
      user: user,
    )
    note2 = project.notes.create(
      message: "This is the second note.",
      user: user,
    )
    note3 = project.notes.create(
      message: "First, preheat the oven.",
      user: user,
    )

    # note1,2,3より、"message"の文字列がmessageに存在するか検索し検証。
    # 検証の際は配列をチェック。今回の場合空（存在しない）のため、be_emptyを返す。
    expect(Note.search("message")).to be_empty
  end
end
