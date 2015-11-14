Rails.application.routes.draw do
  resources :money

  match ':controller(/:action/(:id))', via: [:get, :port, :patch]
  get ':action' => 'zaimauth#(:action)'

  get 'viz' => 'data_view#viz'

  root 'zaimauth#index'
end
