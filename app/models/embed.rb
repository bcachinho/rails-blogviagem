class Embed < ApplicationRecord
  belongs_to :post
  validates :title, presence: true
  validates :code, presence: true
end
