class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:pending, :approve]

  def create
    @post = Post.find_by!(slug: params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.approved = false  # ← adicionar esta linha

    if @comment.save
      redirect_to @post, notice: "Comentário enviado!"
    else
      redirect_to @post, alert: "Erro ao enviar comentário."
    end
  end

  def destroy
    @post = Post.find_by!(slug: params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy!
    redirect_to pending_comments_path, notice: "Comentário rejeitado/excluído."
  end

  def approve
    @post = Post.find_by!(slug: params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.update!(approved: true)
    redirect_to pending_comments_path, notice: "Comentário aprovado!"
  end

  def pending
    @comments = Comment.where(approved: false).includes(:post, :user).order(created_at: :desc)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Acesso restrito a administradores." unless current_user&.admin?
  end
end

def create
  @post = Post.find_by!(slug: params[:post_id])
  @comment = @post.comments.build(comment_params)
  @comment.user = current_user
end
