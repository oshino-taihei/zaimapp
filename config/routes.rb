Rails.application.routes.draw do
  get 'top' => 'zaimauth#top'
  get 'callback' => 'zaimauth#callback'
  get 'login' => 'zaimauth#login'
  get 'index' => 'zaimauth#index'
  get 'money' => 'zaimauth#money'
  get 'view' => 'zaimauth#view'
end
