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
# Userという名前のモデルのテストをここに書くことを示している。

RSpec.describe User, type: :model do

  # factorybotによってuserが生成されて、それが有効か検証する
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 名がなければ無効な状態であること
  it "is invalid without a first name" do
    # factoryBotによってuserを生成するが、first_nameのみオーバーライドする
    user = FactoryBot.build(:user, first_name: nil)
    # userが有効かどうか検証。今回の場合有効にならない。
    user.valid?
    # そのため、ユーザーのfirst_name属性にエラーメッセージが付いていることを期待(expect)。
    # includeマッチャは、繰り返し可能な値(enumerable value)の中に、ある値が存在するかどうかをチェック。
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がなければ無効な状態であること
  it "is invalid without a last name" do
    # factoryBotによってuserを生成するが、last_nameのみオーバーライドする
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    # factoryBotによってuserを生成するが、emailのみオーバーライドする
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    # ユーザーを一人factoryBotで先に作っておく。
    FactoryBot.create(:user, email: "aaron@example.com")
    #二人のユーザーをbuildで生成し、代入。一人目のメールアドレスと重複しているか検証する。
    user = FactoryBot.build(:user, email: "aaron@example.com")
    # 重複しているかいないかを検証
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    # ユーザーを一人factoryBotで作成
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    # eqは == のこと
    expect(user.name).to eq "John Doe"
  end
end
