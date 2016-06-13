Rails.application.routes.draw do

  resources :kucings
  resources :stock_histories
  
  get 'inventory/index', as: 'inventory'

  get 'inventory/add'

  get 'inventory/check'

  get 'inventory/revise'
  post 'inventory/product_history'

  get 'kucings/tikus'

  get 'home/index' => 'home#index'
  get 'home/login'
  get 'home/logout'
  get 'home/signup'
  get 'home/userlist'

  get 'home/change_password'
  post 'home/verify_change_password' => 'home#verify_change_password'
  post 'home/authentication'
  post 'home/authentication' => 'home#authentication'
  post 'home/create' => 'home#create'
  post 'home/logout' => 'home#logout'

  delete 'home/delete/:id' => 'home#delete'

  get 'customers/index'

  get 'orders/index'
  get 'orders/:id/retrieve_cart' => 'orders#retrieve_cart'
  post 'orders/verify_order'
  post 'orders/confirm_payment'
  post 'orders/confirm_delivery'
  get 'orders/:id/invoice' => 'orders#invoice'
  get 'orders/:id/letter_of_travel' => 'orders#letter_of_travel'

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
  get 'inventory/check/:id' => 'inventory#check'



  
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
