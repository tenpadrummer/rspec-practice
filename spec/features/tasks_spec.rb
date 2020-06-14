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

  # ユーザーがタスクの状態を切り替える
  # js: true というオプションをつけ、指定したテストにてJavaScriptが使える
  # selenium-webdriverというgemが可能としている（CapybaraでのデフォルトのJavaScriptドライバ）
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
    check "Finish RSpec tutorial"

    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck "Finish RSpec tutorial"

    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end
end
