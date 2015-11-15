Rails.application.routes.draw do
  resources :money
  get 'viz' => 'data_view#viz'

  match ':controller(/:action/(:id))', via: [:get, :port, :patch]
  get ':action' => 'zaimauth#(:action)'



  root 'zaimauth#index'
end
