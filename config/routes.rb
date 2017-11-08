Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'category/index'
  root 'store#index', as: 'store_index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'home/hello'
  get 'home/goodbye'

  resources :buyers
  resources :foods
  resources :line_items
  resources :orders
  resources :users
  resources :carts
  resources :vouchers





  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
