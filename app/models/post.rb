class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_one_attached :cover_image   # precisa estar aqui
  has_many_attached :images
  has_rich_text :content

  enum status: { draft: "draft", published: "published" }

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_many :embeds, dependent: :destroy
  accepts_nested_attributes_for :embeds, allow_destroy: true

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  # --- Validações ---
  validate :content_presence
  validate :acceptable_content_attachments
  validate :acceptable_image_attachments

  validates :title, presence: true
  validates :status, presence: true
  validates :slug, uniqueness: true, allow_nil: true
  validates :embed_code, length: { maximum: 2000 }, allow_blank: true

  # --- Escopos ---
  scope :drafts, -> { where(status: :draft) }
  scope :featured, -> { where(featured: true) }
  scope :published, -> { where(status: :published).where('published_at <= ?', Time.current) }
  scope :recent, ->(limit = 5) { published.order(published_at: :desc).limit(limit) }

  # --- Callbacks ---
  before_validation :generate_excerpt, on: :create
  before_validation :set_published_at_default, on: :create

  # --- Métodos de publicação ---
  def publish!
    update!(status: :published, published_at: Time.current) unless published?
  end

  def toggle_publish!
    if published?
      update!(status: :draft, published_at: nil)
    else
      publish!
    end
  end

  # --- Métodos de imagem ---
  # Retorna a capa ou a primeira imagem extra
  def display_cover
    if cover_image.attached?
      cover_image
    elsif images.attached?
      images.first
    else
      nil
    end
  end

  # Retorna a imagem escolhida para carrossel (se houver), senão reutiliza a capa
  # Por enquanto reaproveita a capa
  def display_carousel
    display_cover
  end

  # URL amigável
  def to_param
    "#{id}-#{title.to_s.parameterize}"
  end

  private

  # Gera resumo automático a partir do conteúdo
  def generate_excerpt
    return unless excerpt.blank? && content.present?

    self.excerpt = content.to_plain_text.truncate(250, separator: ' ')
  end

  # Garante que o conteúdo do action_text não está vazio
  def content_presence
    if content.blank? || content.to_plain_text.strip.blank?
      errors.add(:content, "não pode ficar em branco")
    end
  rescue
    errors.add(:content, "não pode ficar em branco")
  end

  # Validação dos arquivos inseridos no Trix/ActionText
  def acceptable_content_attachments
    return unless content&.body

    content.body.attachments.each do |attachment|
      blob = attachment.attachable
      next unless blob

      if blob.byte_size > 5.megabytes
        errors.add(:content, "tem um arquivo maior que 5MB")
      end

      acceptable_types = %w[image/jpeg image/png image/gif image/webp]
      unless acceptable_types.include?(blob.content_type)
        errors.add(:content, "formato de arquivo não permitido")
      end
    end
  end

  # Validação das imagens adicionadas via ActiveStorage direto
  def acceptable_image_attachments
    return unless images.attached?

    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "tem um arquivo maior que 5MB")
      end

      acceptable_types = %w[image/jpeg image/png image/gif image/webp]
      unless acceptable_types.include?(image.blob.content_type)
        errors.add(:images, "formato de arquivo não permitido")
      end
    end
  end

  # FriendlyId — só ativa se tiver slug
  if defined?(FriendlyId) && column_names.include?('slug')
    extend FriendlyId
    friendly_id :title, use: :slugged
  end

  def set_published_at_default
    self.published_at = Time.current if published_at.blank?
  end
end
