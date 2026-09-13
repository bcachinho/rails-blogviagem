class HomeController < ApplicationController
  def index
    # pega até 3 destacados para o carrossel
    @featured_posts = Post.published.featured.order(published_at: :desc).limit(3)

    # pega os mais recentes que *não* são featured
    @recent_posts   = Post.published.where(featured: false).order(published_at: :desc).limit(6)
  end
end
