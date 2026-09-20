class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @query = params[:q]

    favorites = current_user.favorite_posts

    if @query.present?
      q = "%#{@query.downcase}%"
      favorites = favorites.joins("LEFT JOIN action_text_rich_texts
                                    ON action_text_rich_texts.record_id = posts.id
                                    AND action_text_rich_texts.record_type = 'Post'")
                           .where("LOWER(posts.title) LIKE :q
                                   OR LOWER(posts.excerpt) LIKE :q
                                   OR LOWER(action_text_rich_texts.body) LIKE :q", q: q)
    end

    @favorites = favorites.order(published_at: :desc)
  end

  def create
    post = Post.friendly.find(params[:post_id])
    current_user.favorites.find_or_create_by(post: post)
    redirect_back fallback_location: posts_path, notice: "Post adicionado aos favoritos!"
  end

  def destroy
    post = Post.friendly.find(params[:post_id])
    favorite = current_user.favorites.find_by(post: post)
    favorite&.destroy
    redirect_back fallback_location: posts_path, notice: "Post removido dos favoritos!"
  end
end
