Rails.application.routes.draw do
  devise_for :users
  resources :accesses

  get 'profile' => 'users#profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'users#profile'
end
