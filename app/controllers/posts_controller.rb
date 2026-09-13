class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_draft_count
  before_action :authorize_admin!, except: [ :index, :show, :my_posts ]
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :preview, :publish ]
  before_action :set_draft_count
  before_action :authorize_admin!, except: [ :index, :show, :my_posts ]
  load_and_authorize_resource except: :my_posts
  load_and_authorize_resource except: :my_posts
  protect_from_forgery except: :preview_live

  def index
    @query = params[:q]

    posts = Post.published.order(published_at: :desc)
    posts = posts.joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = posts.id AND action_text_rich_texts.record_type = 'Post'")

    if @query.present?
      q = "%#{@query.downcase}%"
      posts = posts.where(
        "LOWER(posts.title) LIKE :q OR LOWER(posts.excerpt) LIKE :q OR LOWER(action_text_rich_texts.body) LIKE :q",
        q: q
      )
    end

    # Separação p/ index.html.erb
    @featured_posts = posts.select { |p| p.featured? && p.cover_image.attached? }
    @recent_posts   = posts.reject(&:featured?)

    @posts = posts
  end

  def show
    # @post carregado pelo CanCanCan
  end

  def new
    @post = current_user.posts.build
    @post.published_at = Time.current # Preenche com a data/hora atual
    authorize! :create, @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize! :create, @post

    case params[:commit_type]
    when "draft"
      @post.status = :draft
      @post.published_at = nil
    when "publish"
      @post.status = :published
      @post.published_at ||= Time.current
    when "preview"
      @post.status = :draft
      return render :preview
    end

    if @post.save
      redirect_to @post, notice: "Post criado com sucesso."
    else
      flash.now[:alert] = "Há erros no formulário."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    authorize! :update, @post

    case params[:commit_type]
    when "draft"
      @post.status = :draft
      @post.published_at = nil
    when "publish"
      @post.status = :published
      @post.published_at ||= Time.current
    when "preview"
      temp_post = @post.dup
      temp_post.assign_attributes(post_params)
      temp_post.status = :draft
      return render :preview, locals: { post: temp_post }
    end

    if @post.update(post_params)
      redirect_to @post, notice: "Post atualizado com sucesso!"
    else
      flash.now[:alert] = "Há erros no formulário."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @post
    @post.destroy!
    redirect_to my_posts_posts_path, status: :see_other, notice: "Post removido com sucesso."
  end

  def preview
    authorize! :read, @post
    render :preview
  end

  def preview_live
    @post = Post.new(post_params)
    @post.status = :draft
    render :preview
  end

  def publish
    authorize! :update, @post
    @post.update!(status: :published, published_at: Time.current)
    redirect_to @post, notice: "Post publicado com sucesso!"
  end

  def my_posts
    if current_user.admin?
      @published = Post.published.order(published_at: :desc)
      @drafts    = Post.draft.order(created_at: :desc)
    else
      @published = current_user.favorite_posts.published.order(published_at: :desc)
      @drafts    = []
    end
  end

  private

  def post_params
    permitted = [:title, :excerpt, :content, :status, :published_at, :cover_image, :text_alignment,
                images: [],
                embeds_attributes: [:id, :title, :code, :_destroy]]
    permitted << :featured if current_user&.admin?
    params.require(:post).permit(permitted)
  end

  def set_post
    @post = Post.find_by!(slug: params[:id])
  end

  def set_draft_count
    if user_signed_in?
      @draft_count = current_user.admin? ? Post.draft.count : current_user.posts.draft.count
    else
      @draft_count = 0
    end
  end

  def authorize_admin!
    redirect_to root_path, alert: "Acesso restrito a administradores." unless current_user&.admin?
  end
end
