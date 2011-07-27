Artsready::Application.routes.draw do

  get "needs/create"

  get "get_help" => "buddies#get_help", :as => "get_help"
  get "lend_a_hand" => "buddies#lend_a_hand", :as => "lend_a_hand"
  get "buddies" => "buddies#index", :as => "buddies"
  get "buddies/profile"

  namespace :admin do
    resources :users, :only => [:index, :edit, :update]
    resources :organizations, :only => [:index, :edit, :update]
    get 'home/dashboard', :as => "dashboard"
  end

  resources :articles do
    get 'critical_list', :on => :collection
  end
  
  match "/articles/new/(:id)" => "articles#new"

  resources :resources
  resources :organizations, :only => [:edit, :update, :show, :new, :create] do
    resources :users
  end
  
  resources :crises do
    resources :updates
    resources :needs, :only => [:create, :edit, :update]
  end

  resource :assessment, :only => [:new, :create, :show]
  resources :answers, :only => [:update] do
    member do
      put 'skip'
      put 'reconsider'
    end
  end
  
  resources :todos
  resources :todo_notes

  get "sign_up" => "organizations#new", :as => "sign_up"
  get "sign_in" => "sessions#new", :as => "sign_in"
  post "sign_in" => "sessions#create"
  get "sign_out" => "sessions#destroy", :as => "sign_out"

  resources :users, :only => [:new, :create, :edit, :update]

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
