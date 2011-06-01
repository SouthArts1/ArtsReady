Artsready::Application.routes.draw do

  get "sign_up" => "users#new", :as => "sign_up"  
  get "sign_in" => "sessions#new", :as => "sign_in"  
  post "sign_in" => "sessions#create"
  get "sign_out" => "sessions#destroy", :as => "sign_out"  
  
  resources :users
  get "member/index"
  get "home/index"
  root :to => "home#index"

  # match ':controller(/:action(/:id(.:format)))'
end
