Buycall::Application.routes.draw do

  root :to => 'home#index'
  resources :orders

end
