Rails.application.routes.draw do
  root 'pages#index'

  resource :session, only: %i[new create destroy]

  resources :users, except: %i[index destroy]

  resources :questions do
    resources :answers, only: %i[create edit update destroy]
  end
end
