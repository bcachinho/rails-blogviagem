class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { reader: 0, admin: 1 }

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :downcase_email

  def favorite?(post)
    favorite_posts.exists?(post.id)
  end

  def favorite!(post)
    favorites.find_or_create_by!(post: post)
  end

  def unfavorite!(post)
    favorites.find_by(post: post)&.destroy
  end

  private

  def downcase_email
    self.email = email.to_s.downcase
  end
end
