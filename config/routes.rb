Buycall::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  get "twiml/start"
  get "twiml/ask_region"
  get "twiml/question"
  get "twiml/finish"

  resources :users
  resources :orders
  root :to => 'home#index'

end
