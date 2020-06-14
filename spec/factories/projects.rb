# factorybotはテストデータのセットアップをおこなってくれる
FactoryBot.define do
  # 下記の記述により、テスト内で FactoryBot.create(:project)と書けば
  # 簡単に新しいユーザーを作成できる。
  # Projectモデルのスペックで使用可能

  factory :project do
    # プロジェクト名もシーケンスで作成の度にカウンタが変動する。
    sequence(:name) { |n| "Project #{n}" }
    description "Sample project for testing purposes"
    due_on 1.week.from_now
    # ownerというエイリアス（別名のこと）をつけておく。
    # FactoryBotを使う際はユーザーファクトリに対してownerという名前で参照される場合があると伝える必要がある。
    # belongs_to :owner, class_name: 'User', foreign_key: :user_idに関わる
    association :owner

    # 以下は:projectファクトリの内部で入れ子になっているため、
    # ユニーク属性つまり変更したいもの以外は継承されている。
    # 継承を使うとclass: Projectの指定もなくすことができる。

    # メモ付きのプロジェクト
    trait :with_notes do
      # 新しいプロジェクトを作成した後にメモファクトリを使って5つの新しいメモを追加
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    # 昨日が締め切りのプロジェクト
    factory :project_due_yesterday do
      due_on 1.day.ago
    end

    # 今日が締め切りのプロジェクト
    factory :project_due_today do
      due_on Date.current.in_time_zone
    end

    # 明日が締め切りのプロジェクト
    factory :project_due_tomorrow do
      due_on 1.day.from_now
    end

    #無効になっているproject
    trait :invalid do
      # nameはnilとするため無効
      name nil
    end
  end
end

# コードの重複を減らすには、traitを使用する方法もある。
# トレイトを使うメリットは、複数のトレイトを組み合わせて複雑なオブジェクトを構築でき る点
# トレイトを使用する際はスペックも変更する必要がある。