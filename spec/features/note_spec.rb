# この記述はテストにおいてほぼすべてのファイルで必要
require 'rails_helper'

RSpec.feature "Notes", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user
    )
  }

  # ユーザーが添付ファイルをアップロードする
  scenario "user uploads an attachment" do
    sign_in user
    visit project_path(project)
    click_link "Add Note"
    fill_in "Message", with: "My book cover"
    # Capybaraのattach_fileメソッドを使って、ファイルを添付する処理をシミュレート.
    # 最初の引数は入力項目のラベル゙、二つ目の引数がテストファイルのパス.ファイルは忘れずgitでコミットしておくこと。
    attach_file "Attachment", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "Create Note"

    expect(page).to have_content "Note was successfully created"
    expect(page).to have_content "My book cover"
    expect(page).to have_content "attachment.jpg (image/jpeg"
  end
end
