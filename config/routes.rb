Buycall::Application.routes.draw do
  root :to => 'home#index'

  resources :products
  resources :orders

  get "orders", :to => "orders#index"

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
