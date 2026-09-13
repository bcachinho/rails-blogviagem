Rails.application.routes.draw do
  devise_for :users

  # Rota raiz (homepage)
  root "home#index"  # ou root "posts#index" se preferir posts como homepage

  # Rotas dos recursos principais
  resources :posts do
    # comentários dentro de posts (criação + aprovação)
    resources :comments, only: [:create, :destroy] do
      member do
        patch :approve
      end
    end

    # favoritos (POST para criar, DELETE para remover)
    resource :favorite, only: [:create, :destroy]

    member do
      get :preview
      patch :publish
    end

    collection do
      post :preview_live  # preview de alterações ainda não salvas
      get :my_posts
    end
  end

  # Página centralizada só para admin ver pendentes (fora de posts)
  resources :comments, only: [] do
    collection do
      get :pending   # GET /comments/pending
    end
  end



  # Página com todos os favoritos do usuário logado
  resources :favorites, only: [:index]

  # Área administrativa (se for usar ainda mais separado)
  namespace :admin do
    resources :posts
    resources :comments
    resources :users
  end

  # Outras rotas estáticas se necessário
  get "pages/home"
end
