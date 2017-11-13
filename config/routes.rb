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
  get 'foods/search'
  get 'restaurants/search'
  get 'orders/search'
  get 'admin/foods'
  get 'admin/restaurants'
  get 'admin/orders'

  resources :buyers
  resources :foods do
    resources :reviews, only: [:index, :new, :create]
  end
  resources :line_items
  resources :orders
  resources :users
  resources :carts
  resources :vouchers
  resources :tags
  resources :restaurants do
    resources :reviews, only: [:index, :new, :create]
  end
  resources :reviews

  # mount Blazer::Engine, at: "blazer"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
