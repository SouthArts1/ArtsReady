Artsready::Application.routes.draw do

  match "/billing/my_organization" => "billing#my_organization"
  match "/billing/cancel/(:id)" => "billing#cancel", :as => "billing_cancel"
  match "/billing/new/(:code)" => "billing#new", :as => 'billing_new'
  match "/billing/(:id)/edit/(:code)" => "billing#edit", :as => "billing_edit"
  resources :billing

  get "messages/create"
  get "needs/create"

  get "get_help" => "buddies#get_help", :as => "get_help"
  get "lend_a_hand" => "buddies#lend_a_hand", :as => "lend_a_hand"
  get "buddies" => "buddies#index", :as => "buddies"
  get "buddy(/:id)" => "buddies#show", :as => "buddy"
  get "buddies/profile"

  namespace :admin do
    get 'home/dashboard', :as => "dashboard"
    get "/organizations/billing/(:id)" => "organizations#billing"
    get "/discount_codes/disabled" => "discount_codes#disabled"
    get "/discount_codes/usage" => "discount_codes#usage"
    get "/discount_codes/show_usage/(:id)" => "discount_codes#show_usage"
    match "/organizations/allow_provisionary_access/(:id)" => "organizations#allow_provisionary_access"
    
    resources :organizations, :only => [:index, :edit, :update, :destroy] do
      resources :users, :only => [:index, :create, :destroy, :edit, :update]
    end
    resources :users, :only => [:index]
    resources :password_resets, :only => [:create]
    resources :articles, :only => [:update, :destroy, :index]
    resources :comments, :only => [:destroy]
    resources :messages, :only => [:destroy]
    resources :pages, :only => [:index, :edit, :update]
    resources :questions
    resources :action_items
    resources :discount_codes
    resources :payment_variables
    root :to => 'home#dashboard', :as => "dashboard"
  end

  resources :articles do
    get 'critical_list', :on => :collection
    resources :comments, :only => [:create]
  end
  
  resources :resources
  resources :organizations, :only => [:edit, :update, :show, :new, :create] do
    resources :articles do
      get 'critical_list', :on => :collection
    end
    resources :crises, :only => [:index] do
      member do
        get 'summary'
      end
    end
    resources :battle_buddy_requests, :only => [:create, :show, :index, :update, :destroy]
    resources :messages, :only => [:create]
    resources :users
  end
  
  resources :crises do
    resources :updates
    resources :needs, :only => [:create, :edit, :update]
  end

  resources :archived_assessments, :only => [:index, :show]
  resource :assessment, :only => [:new, :create, :show] do
    resources :sections, :only => [:update]
  end
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

  match 'confirm(/:id)' => 'password_resets#edit', :as => :confirmation
  
  resources :users, :only => [:new, :create, :edit, :update, :destroy]
  get "profile" => "users#profile", :as => "profile"
  
  resources :password_resets, :only => [:new, :create, :edit, :update]
  get "member/index", :as => "dashboard"
  get "member/library", :as => "library"

  # public pages
  get "page/:slug" => "pages#show", :as => "page"
  match '/offer' => 'pages#show', :slug => 'afta' 

  get "welcome" => "home#welcome", :as => "welcome"

  get "readiness_library" => "home#readiness_library", :as => "readiness_library"
  get "home/public_articles" => "home#public_articles", :as => "public_articles"
  get "home/public_article(/:id)" => "home#public_article", :as => "public_article"
  get "news" => "home#news", :as => "news"
  root :to => "home#index"

end
