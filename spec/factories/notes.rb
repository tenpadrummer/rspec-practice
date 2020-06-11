# factorybotはテストデータのセットアップをおこなってくれる
FactoryBot.define do
  # 下記の記述により、テスト内で FactoryBot.create(:project) と書けば
  # 簡単に新しいユーザーを作成できる。
  # つまり、スペック全体でファクトリが使える
  factory :project do
    # プロジェクト名もシーケンスで作成の度にカウンタが変動する。
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."
    due_on 1.week.from_now
    # ownerというエイリアス（別名のこと）をつけておく。
    # FactoryBotを使う際はユーザーファクトリに対してownerという名前で参照される場合があると伝える必要がある。
    # belongs_to :owner, class_name: 'User', foreign_key: :user_idに関わる
    association :owner
  end
end
