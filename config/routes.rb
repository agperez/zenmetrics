Rails.application.routes.draw do

  resources :gifs

  resources :refresh_audits

  resources :users

  resources :tickets

  namespace :api, defaults: {format: :json} do
    resources :tickets do
      get :stats, on: :collection
    end

    resources :gifs do
      get :get, on: :collection
    end
  end

  root 'tickets#month'

  match '/audits', to: 'static#audits', via: 'get'
  match '/refresh_all', to: 'tickets#refresh', via: 'get'
  match '/refresh_users', to: 'users#refresh', via: 'get'
  match '/month', to: 'tickets#month', via: 'get'
  match '/agents', to: 'tickets#agents', via: 'get'
  match '/refresh_day', to: 'tickets#refresh_day', via: 'get'
  match '/previous', to: 'tickets#previous', via: 'get'
  match '/week', to: 'tickets#week', via: 'get'
  match '/previous_week', to: 'tickets#previous_week', via: 'get'


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
