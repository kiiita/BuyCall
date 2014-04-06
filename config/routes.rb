Buycall::Application.routes.draw do
  root :to => 'home#index'

  resources :products
  resources :orders

  get 'twiml/start'

  get 'twiml/ask_product'
  get 'twiml/receive_product'

  get 'twiml/ask_count/:product_id' => 'twiml#ask_count'
  get 'twiml/receive_product_and_count/:product_id' => 'twiml#receive_product_and_count'

  get 'twiml/confirm_product/:product_id/:count' => 'twiml#confirm_product'

  get 'twiml/ask_name'
  get 'twiml/receive_name'

  get 'twiml/ask_zip'
  get 'twiml/receive_zip'
  get 'twiml/confirm_zip'

  get 'twiml/ask_address'
  get 'twiml/confirm_zip'

  get 'twiml/ask_address2'
  get 'twiml/receive_address2'

  get 'twiml/ask_order'
  get 'twiml/confirm_order'

  get 'twiml/finish'

  get 'aitalk/play' => 'aitalk#play', as: 'aitalk'
end
