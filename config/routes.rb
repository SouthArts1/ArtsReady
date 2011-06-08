Artsready::Application.routes.draw do

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
    resources :organizations, :only => [:index, :edit, :update]
  end

  resources :organizations, :except => [:index, :destroy]

  get "sign_up" => "users#new", :as => "sign_up"  
  get "sign_in" => "sessions#new", :as => "sign_in"  
  post "sign_in" => "sessions#create"
  get "sign_out" => "sessions#destroy", :as => "sign_out"  
  
  resources :users
  
  get "member/index", :as => "dashboard"

  # public pages
  get "home/index"
  get "about" => "home#about", :as => "about"
  get "contact" => "home#contact", :as => "contact"
  get "faq" => "home#faq", :as => "faq"
  get "links" => "home#links", :as => "links"
  get "sitemap" => "home#sitemap", :as => "sitemap"
  get "support" => "home#support", :as => "support"
  get "tour" => "home#tour", :as => "tour"
  
  get "tbd" => "dev#tbd", :as => "tbd"
  root :to => "home#index"

  # match ':controller(/:action(/:id(.:format)))'
end
