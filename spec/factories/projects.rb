# factorybotはテストデータのセットアップをおこなってくれる
FactoryBot.define do
  # 下記の記述により、テスト内で FactoryBot.create(:) と書けば
  # 簡単に新しいユーザーを作成できる。
  # つまり、スペック全体でファクトリが使える
  factory :note do
    message "My important note."
    association :project
    user { project.owner }
  end
end