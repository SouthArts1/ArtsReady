Artsready::Application.routes.draw do

  resources :users
  get "member/index"
  get "home/index"
  root :to => "home#index"

  # match ':controller(/:action(/:id(.:format)))'
end
