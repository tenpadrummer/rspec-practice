# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

# feature_specはつまり統合テストのこと。
# 単体テストはその一つ一つの機能に対して検証する
# 統合テストは開発したソフトウェア全体が一つのシステムとして期待どおりに動くことを検証する
# ようするに、アプリケーションの実際の使われ方をシミュレート
# Capybaraは、UIテストのためのrubyフレームワーク
# Capybaraを使うと高レベルなテストを実現可能。gemのtestグループにて使用すればメモリも軽く済む
# ページの表示、フォームの入力、ボタンのクリック等のUI操作をテストコード上で実行できるのがCapybara
# MiniTest, RSpec, Cucumberといった複数のテストフレームワークから利用できる
# features/projects_spec.rbに詳しく記載

RSpec.feature "Tasks", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user)
    )
  }

  let!(:task) {
    project.tasks.create!(name: "Finish RSpec tutorial")
  }

  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    sign_in user
    go_to_project "RSpec tutorial"

    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
    expect(task.reload).to_not be_completed
  end
end


# ----------------------------------
# ここから下はリファクタ前のコード
# ----------------------------------

# ユーザーがタスクの状態を切り替える
scenario "user toggles a task", js: true do
  user = FactoryBot.create(:user)
  # オーナーはuserのprojectを生成
  project = FactoryBot.create(:project, name: "RSpec tutorial", owner: user)
  task = project.tasks.create!(name: "Finish RSpec tutorial")

  visit root_path
  click_link "Sign in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"

  click_link "RSpec tutorial"

  # "Finish RSpec tutorial"にチェックを入れた場合
  check "Finish RSpec tutorial"

  # expect(page).to have_cssは指定したCSSに一致する要素が存在することを検証
  expect(page).to have_css "label#task_#{task.id}.completed"
  # reloadメソッドでtaskをリロード、それが完了するか検証
  expect(task.reload).to be_completed

  # "Finish RSpec tutorial"のチェックを外した場合
  uncheck "Finish RSpec tutorial"

  # expect(page).to_not have_cssは指定したCSSに一致する要素が存在しないことを検証
  expect(page).to_not have_css "label#task_#{task.id}.completed"
  expect(task.reload).to_not be_completed
end

# 本当に遅い処理を実行する
scenario "runs a really slow process " do
  using_wait_time(15) do
    # テストを実行する
  end
end

# js: true というオプションをつけることで、指定したテストにてJavaScriptが使える。selenium-webdriverというgemが可能としている（CapybaraでのデフォルトのJavaScriptドライバ）
