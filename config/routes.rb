Buycall::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root :to => 'home#index'

  resources :products

  resource :orders


  get "twiml/start"

  get "twiml/ask_product"
  get "twiml/receive_product"
  get "twiml/confirm_product/:product_id" => 'twiml#confirm_product'

  get "twiml/ask_name"
  get "twiml/receive_name"

  get "twiml/ask_zip"
  get "twiml/receive_zip"
  get "twiml/confirm_zip"

  get "twiml/ask_address"
  get "twiml/confirm_zip"

  get "twiml/ask_address2"
  get "twiml/receive_address2"

  get "twiml/ask_order"
  get "twiml/confirm_order"

  get "twiml/finish"

end
