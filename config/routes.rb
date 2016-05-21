Rails.application.routes.draw do
  resources :stock_histories
  
  get 'inventory/index'

  get 'inventory/add'

  get 'inventory/check'

  get 'inventory/revise'

  get 'home/index'
  get 'home/login'
  get 'home/logout'
  get 'home/signup'
  get 'home/userlist'

  post 'home/authentication'
  post 'home/authentication' => 'home#authentication'
  post 'home/create' => 'home#create'
  post 'home/logout' => 'home#logout'
  delete 'home/delete' => 'home#delete'

  get 'customers/index'

  get 'orders/index'
  get 'orders/payment'
  get 'orders/deliver'

  get 'order_items/index'
  get 'bike_models/index'
  get 'products/index'
  get 'stocks/index'

  get 'home/test' => 'home#test' 

  resources :order_items
  resources :orders
  
  resources :users

  resources :stocks
  resources :stock_histories

  resources :products
  resources :bike_models
  
  resources :customers

  root 'home#index', as: 'home'
  post 'products/:id/cek' => 'products#cek'
  get 'inventory/:id/check' => 'inventory#check'



  
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
