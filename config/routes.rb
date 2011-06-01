Artsready::Application.routes.draw do

  get "sign_up" => "users#new", :as => "sign_up"  
  resources :users
  get "member/index"
  get "home/index"
  root :to => "home#index"

  # match ':controller(/:action(/:id(.:format)))'
end
