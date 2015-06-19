Rails.application.routes.draw do
  get 'welcome/index'

  get 'scoreboard/index'

  resources :bids

  resources :auctions

  resources :events

  resources :submissions

  resources :problems

  resources :levels

  resources :chapters

  resources :teams

  resources :contests do
    #resources :teams
  end

  resources :votes

  resources :comments

  resources :cloth_sets do
    resources :comments
  end

  resources :cloth_parts do
    resources :comments
  end

  resources :profiles

  get '/scoreboard' => 'teams#scoreboard'
  put '/submissions/accept/:id/:pid' => 'submissions#accept'
  put '/submissions/reject/:id/:pid' => 'submissions#reject'
  root to: 'profiles#index'

  put '/problems/buy/:id' => 'problems#buy'

  get '/follow' => 'profiles#follow_list'
  put '/profiles/follow/:id' => 'profiles#follow'
  patch '/profiles/follow/:id' => 'profiles#follow'
  delete '/profiles/follow/:id' => 'profiles#unfollow'
  get '/discover' => 'problems#index'

  get '/regals/add_cp/:cpid' => 'regals#add_cp'
  post '/regals/:id/:cpid' => 'regals#add'
  delete '/regals/:id/:cpid' => 'regals#remove'

  devise_for :users, path: 'auth', path_names: {sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'new'}, :controllers => {:omniauth_callbacks => 'omniauth_callbacks'}

  get '/:username' => 'profiles#show_with_username'
  get '/:username/following' => 'profiles#following'
  get '/:username/followers' => 'profiles#followers'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
