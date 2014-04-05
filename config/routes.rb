Buycall::Application.routes.draw do

  get "twiml/start"
  get "twiml/ask_region"
  get "twiml/question"
  get "twiml/finish"

  resources :users
  resources :orders
  root :to => 'home#index'

end
