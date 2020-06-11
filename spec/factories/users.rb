# factorybotはテストデータのセットアップをおこなってくれる
FactoryBot.define do
  # 下記の記述により、テスト内で FactoryBot.create(:user) と書けば
  # 簡単に新しいユーザーを作成できる。
  # つまり、スペック全体でファクトリが使える
  factory :user do
    first_name "Aaron"
    last_name "Sumner"
    #　シーケンスを使えば、ユニークバリデーションを持つフィールドを扱うことができる。
    # 今回の例は、ファクトリから新しいオブジェクトを作成するたびに、カウンタの値を1つずつ増やしながら、ユニークにならなければいけない属性に値を設定
    # こうすれば新しいユーザーを作成するたびに、tester1@example.com 、tester2@example.comというように、ユニークで連続したメールアドレスが設定されます。
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "dottle-nouveau-pavilion-tights-furze"
  end
end
