class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user

  delegate :name, to: :user, prefix: true

  validates :message, presence: true

  # 渡された文字列でメモ(note)を検索する機能を用意してあります。この機能はNoteモデルにスコープとして実装してある
  scope :search, ->(term) {
    where("LOWER(message) LIKE ?", "%#{term.downcase}%")
  }

  has_attached_file :attachment

  validates_attachment :attachment,
    content_type: {
      content_type: [
        "image/jpeg",
        "image/gif",
        "image/png",
        "application/pdf",
      ],
    }
end
