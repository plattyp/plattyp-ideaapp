Ideaapp::Application.routes.draw do
  get "subfeaturecategories/index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}
  as :user do
    put "registrations/signup", :to => "registrations#signup", :as => "signup"
  end
  ActiveAdmin.routes(self) unless ARGV.grep(/assets:precompile/).any?

  #Create a route so that the steps can be moved with the create tracker
  resources :ideas do
    collection do
      get :next_step
      post :next_step
    end
  end

  #Set relationship between ideas and features
  resources :users do
    resources :ideas
  end

  resources :groups do
    resources :ideatypes
  end

  #The relationship for the users that are a part of an idea's workroom
  resources :ideas do
    resources :ideausers
  end

  #The invitation to join an idea's workroom
  resources :ideas do
    resources :invitedusers
  end

  #The route to create subfeature categories
  resources :ideas do
    resources :subfeaturecategories
  end

  resources :ideas do
    resources :features do
      resources :subfeatures
    end
  end

  resources :ideas do
    resources :domains, :controller => 'domains'
  end

  #The association to domains
  resources :ideas do
    resources :ideadomains, :controller => 'ideadomains'
  end

  resources :ideas do
    resources :ideamessages, :controller => 'ideamessages'
  end

  #For settings
  resources :settings do
    collection do
      get :signupcode
    end
  end


  #Set homepage
  root to: "ideas#index"




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
