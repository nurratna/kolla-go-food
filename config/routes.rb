Rails.application.routes.draw do
  # get 'orders/index'

  get 'category/index'

  resources :carts
  # get 'store/index'
  root 'store#index', as: 'store_index'

  resources :buyers
  resources :foods
  resources :line_items
  resources :orders

  get 'home/hello'
  get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
