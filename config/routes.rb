Artsready::Application.routes.draw do

  get "buddies/get_help"
  get "buddies/lend_a_hand"
  get "buddies/index"
  get "buddies/profile"

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
    resources :organizations, :only => [:index, :edit, :update]
    get 'home/dashboard', :as => "dashboard"
  end

  resources :articles do
    get 'critical_list', :on => :collection
  end

  resources :resources
  resources :organizations, :only => [:edit, :update, :show]
  resources :assessments
  resources :answers
  resources :todos

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
  get "welcome" => "home#welcome", :as => "welcome"

  get "library" => "home#library", :as => "library"
  get "home/public_article(/:id)" => "home#public_article", :as => "public_article"
  get "tbd" => "home#tbd", :as => "tbd"
  root :to => "home#index"

  # match ':controller(/:action(/:id(.:format)))'
end
