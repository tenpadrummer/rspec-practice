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
  # featureもdescribeと同様にスペックを構造化していく

  # ユーザーは新しいプロジェクトを作成するというシュミレート
  # 今回の例はhome#index、sessions#new、projects#index、projects#new、projects#createを動かしている

  # scenarioはitと同様にexampleの起点となる
  scenario "user creates a new project" do
    # 最初に新しいテストユーザーを作成
    user = FactoryBot.create(:user)

    # トップページにアクセス
    visit root_path
    # ログイン 画面からそのユーザーでログイン
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    # フォームをフィルインしたらログインボタンをクリック
    click_button "Log in"

    # アプリケーションの利用者が使うものと同じフォームを使って新しいプロジェクトを作成できるか期待
    # この中でブラウザ上でテストしたいステップを記述、それから結果の表示が期待どおりになっていることを検証
    expect{
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    }.to change(user.projects, :count).by(1)
    # changeマッチャを使ってテスト、つまり「userがオーナーになっているプロジェクトが本当に増えたかどうか」を検証
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
