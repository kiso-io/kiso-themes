Dummy::Application.routes.draw do
  devise_for :users

  get '/kitchen_sink' => 'home#kitchen_sink'
  root :to => 'home#index'
end
