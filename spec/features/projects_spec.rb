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

RSpec.feature "Projects", type: :feature do

  # login_support.rbのメソッドsign_in_as(user)を呼び出す
  include LoginSupport

  # scenarioはitと同様にexampleの起点となる
  scenario "user creates a new project" do
    # 最初に新しいテストユーザーを作成
    user = FactoryBot.create(:user)
    # rails_helper.rbのconfig.include Devise::Test::IntegrationHelpers, type: :featureを呼び出す
    sign_in user

    visit root_path

    # login_support.rbのメソッドsign_in_as(user)を呼び出す
    # sign_in_as user

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    # 失敗の集約時に使用するaggregate_failures
    # expectを続けて実行することができる
    # 加えて、なぜexpectが失敗したかの原因までわかりやすくなる。
    # テストが成功すれば、aggregate_failuresは関係ない
    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  # テスト稼働開発のプラクティス(TDD)

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    # プロジェクトを持ったユーザーを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    # ユーザーはログインしている
    login_as user, scope: :user
    # ユーザーがプロジェクト画面を開き、
    # "complete" ボタンをクリックすると,
    # プロジェクトは完了済みとしてマークされる
    visit project_path(project)

    expect(page).to_not have_content "Completed"

    click_button "Complete"

    # Capybaraのsave_and_open_pageメソッドは、RSpecテスト中の任意の箇所をブラウザで確認できる方法
    # save_and_open_page

    # 上記ステップへの期待
    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end


# --------------------
# 単体テスト　<=>　統合テスト
# ・describe <=> feature
# ・it <=> scenario
# ・let <=> given
# ・let! <=> given!
# ・before <=> background
# --------------------
# CapybaraのDSL。明示的に記述していく
# ・visitでページを訪問
# ・click_linkでリンクをクリック
# ・fill_in, withフォームの入力項目に値を入れる
# ・click_buttonでボタンクリック
# ・checkはチェックボックスのラベルにチェック
# ・uncheckはチェックボックスのラベルのチェックを外す
# ・chooseはラジオボタンのラベルを選択
# ・selectはセレクトメニューからオプションを選択
# ・attach_fileはファイルアップロードのラベルでファイルを添付
# ・findは画面に表示されている値を指定して特定の要素を検索する
# ・expect(page).to have_cssは指定したCSSに一致する要素が存在することを検証
# ・expect(page).to have_selectorhs指定したセレクタに一致する要素が存在することを検証
# ・expect(page).to have_current_pathhs現在のパスが指定されたパスであることを検証
# ・expect(page).to have_contentはページ内に特定の文字列が表示されていることを検証する
