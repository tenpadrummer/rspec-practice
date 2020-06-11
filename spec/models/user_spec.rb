# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# 期待する結果をまとめて記述(describe)。
# example(itで始まる1行)一つにつき、結果を一つだけ期待している。
# Userという名前のモデルのテストをここに書くことを示している。
RSpec.describe User, type: :model do

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a first name, last name, email, and password" do
    # 上記it(example)検証のためのuserを作成する。
    user = User.new(
      first_name:   "Aaron",
      last_name:    "Sumner",
      email:        "test@gmail.com",
      password:     "dottle-nouveau-pavilion-tights-furze",
    )
    # be_validはRspecのマッチャ。モデルが有効な状態を理解しているかいないかを検証。
    # userをexpectに渡してマッチャと比較
    # toの反転メソッドにto_notとnot_toが存在する。
    # ちなみに、userモデルにバリデーションを設定していない状態だと、
    # RSpecに対して名を持たないユーザーは無効であると伝えたのに、アプリケーション側がその仕様を実装していないことを意味する。
    expect(user).to be_valid
  end

  # 名がなければ無効な状態であること
  it "is invalid without a first name" do
    # あえてユーザーオブジェクトにfirst_name: nilを渡して作成
    user = User.new(first_name: nil)
    # userが有効かどうか検証。今回の場合有効にならない。
    user.valid?
    # そのため、ユーザーのfirst_name属性にエラーメッセージが付いていることを期待(expect)。
    # includeマッチャは、繰り返し可能な値(enumerable value)の中に、ある値が存在するかどうかをチェック。
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がなければ無効な状態であること
  # このexampleはfirst_nameと同じように行う。
  it "is invalid without a last name" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  # このexampleはfirst_nameと同じように行う。
  it "is invalid without an email address" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    # ここでは、メールの重複チェックのためテスト前にユーザーを1人保存。
    User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    # 2件目のユーザーをテスト対象のオブジェクトとして生成。
    user = User.new(
      first_name: "Jane",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    # 重複しているかいないかを検証
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string"

end
