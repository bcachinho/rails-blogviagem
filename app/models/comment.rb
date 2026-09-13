class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  # Threading
  belongs_to :parent, class_name: "Comment", optional: true
  has_many   :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true, length: { minimum: 3 }

  # Moderação
  scope :approved, -> { where(approved: true) }
  scope :pending,  -> { where(approved: false) }
end
