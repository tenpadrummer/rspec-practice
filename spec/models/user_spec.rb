# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

RSpec.describe User, type: :model do

  # factorybotによってuserが生成されて、それが有効か検証する
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # first_name, last_name, email, email_case_insensitiveのテストがこの４行に書き換えられる（shoulda-matcher使用時）

  # Shoulda Matchersが提供するvalidate_presence_ofと validate_uniqueness_ofを使用。

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  # バリデーションは大文字と小文字を区別するため以下のコードがある。
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    # ユーザーを一人factoryBotで作成
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    # eqは == のこと
    expect(user.name).to eq "John Doe"
  end
end
