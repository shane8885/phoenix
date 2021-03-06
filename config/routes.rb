Phoenix::Application.routes.draw do

  resources :session_attendances, :only => [:create,:destroy]

  resources :votes, :only => [:create,:destroy]
  
  resources :attendances, :except => [:index] do
    member do
      put 'accept'
    end
  end

  resources :selections, :except => [:index] do
    member do
      put 'promote'
      put 'demote'
      get 'add_review'
      get 'list_reviews'
    end
    collection do
      post 'sort'
    end
  end

  resources :events do
    member do
      get 'selections'
      get 'attendees'
      get 'schedule'
      get 'order_selections'
      get 'schedule_parameters'
      get 'build_schedule'
      get 'update_attendees'
      get 'voting'
      get 'comments'
      get 'calendar'
      get 'new_broadcast'
      post 'broadcast_message'
    end
    collection do
      get 'search'
    end
  end

  resources :event_comments, :except => [:index,:show,:update]  
    
  #devise user registration
  devise_for :users
  #additonal admin actions and user show action
  resources :user do
    collection do
      get 'search'
    end
  end
  
  resources :reviews, :only => [:create,:update, :edit, :destroy]
  
  resources :movie_sessions, :only => [:update,:edit,:show, :destroy]
  
  resources :event_comments, :only => [:update, :edit, :destroy]
  
  get "movies/search"

  get "movies/show"

  get "movies/credits"
  
  get "movies/index"

  get "pages/home"

  get "pages/contact"

  get "pages/about"

  get "pages/help"

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
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
