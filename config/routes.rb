Rails.application.routes.draw do
  # get 'store/index'
  root 'store#index', as: 'store_index'

  resources :buyers
  resources :foods
  get 'home/hello'
  get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
