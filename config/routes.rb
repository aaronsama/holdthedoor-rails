Rails.application.routes.draw do
  devise_for :users
  resources :accesses

  get 'profile' => 'users#profile'
  post 'open' => 'gate#open', defaults: { format: :json }

  root to: 'users#profile'
end
