Buycall::Application.routes.draw do

  root :to => 'home#index'

  resources :products
  resources :orders
  resources :users
end
