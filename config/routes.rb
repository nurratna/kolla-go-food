Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  # get 'orders/index'

  get 'category/index'


  # get 'store/index'
  root 'store#index', as: 'store_index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :buyers
  resources :foods
  resources :line_items
  resources :orders
  resources :users
  resources :carts



  get 'home/hello'
  get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
