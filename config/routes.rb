Rails.application.routes.draw do
  resources :carts
  # get 'store/index'
  root 'store#index', as: 'store_index'

  resources :buyers
  resources :foods
  resources :line_items
  
  get 'home/hello'
  get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
