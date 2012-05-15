Casecreed::Application.routes.draw do


  resources :sms do
    member do
      put 'verify_phone'
      get 'send_verification_code_again'
    end

  end

  resources :vote_for_next_cities

  resources :slots, :only=>[:index, :show,:new] do
    member do
      get "disable"
      get "enable"
    end
  end

  resources :appointments
  resources :casecreedblog
  resources :available_timings

  resources :ratings

  resources :images

  get "pages/about_us"
  get "pages/presskit"
  get "pages/logo"
  get "pages/privacy_policy"
  get "pages/terms_of_use"
  get "pages/how_it_works"
  get "pages/logo"
  get "pages/homepage"

  resources :search_accounts, :only=>[:index,:create] do
    member do
      get "claim"
      post "request_sent"
    end

    collection do
      post "search"
      get "search"
      get 'pending_request'
      post 'authenticate_requests'
    end
  end

  resources :messages, :only=>[:new,:show,:index,:create]


  resources :lawyers, :only=>[:index, :show,:new,:create] do
    collection do
      post 'search'
      get 'search'
      put 'update_profile'
      get 'edit'
      get 'get_timings_one_lawyer'
    end

    member do
      get "images"
      get "clients"
    end
    resources :specialities, :only=>[:new,:destroy, :create]
  end

  resources :reviews
  resources :categories,:except=>[:show] do
    collection do
      post 'get_sub_categories'
    end
  end

  resources :users do
    collection do
      get 'account_activate'
      get 'pending_request'
      post 'authenticate_requests'
      get  'settings'
      get 'no_sms_updates'
      put 'update_password'
    end


    member do
      get "lawyers"
    end

  end

  resources :forgot_password,:only=>[:create, :new] do
    collection do
      get 'change_password'
      post 'update_password'
    end
  end

  match 'home' => 'sessions#home', :as => :home
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'user_sign_up'=>'users#new',:as=>:user_sign_up
  match 'lawyer_sign_up'=>'lawyers#new',:as=>:lawyer_sign_up
  match 'select_user_type' => 'pages#select_user_type', :as=>:select_user_type
  match 'sessions/create' => 'sessions#create'
  root :to => "sessions#home"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

