class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # visitante (não logado)

    # === TODOS (visitantes e logados) ===
    can :read, Post, status: "published"  # posts publicados são públicos
    can :read, Comment                    # comentários são públicos
    can :read, Category                   # categorias são públicas

    # === USUÁRIOS LOGADOS ===
    if user.persisted?
      # Posts
      can :create, Post                           # pode criar posts
      can :my_posts, Post                         # pode acessar "Meus Posts"
      can :preview_live, Post                     # pode fazer preview sem salvar
      can [:read, :update, :destroy, :preview], Post, author_id: user.id  # gerencia próprios posts
      can :read, Post, author_id: user.id         # pode ver próprios rascunhos

      # Comentários
      can :create, Comment                        # pode comentar
      can [:update, :destroy], Comment, user_id: user.id  # gerencia próprios comentários

      # Favoritos
      can :create, Favorite
      can :destroy, Favorite, user_id: user.id
    end

    # === ADMIN ===
    if user.admin?
      can :manage, Post
      can :manage, Comment
    elsif user.present?
      can :read, Post, status: :published
      can :create, Comment
    else
      can :read, Post, status: :published
    end
  end
end
