Buycall::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root :to => 'orders#index'

  resources :products
  resources :orders

  get "twiml/start"
  get "twiml/ask_shop"
  get "twiml/ask_product"
  get "twiml/confirm_product"
  get "twiml/ask_name"
  get "twiml/ask_zip"
  get "twiml/ask_address"
  get "twiml/confirm_address"
  get "twiml/finish"

end
