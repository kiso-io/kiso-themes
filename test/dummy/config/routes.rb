Dummy::Application.routes.draw do
  devise_for :users

  get '/kitchen_sink' => 'home#kitchen_sink'
  get '/css' => 'home#css'
  get '/components' => 'home#components'
  get '/javascript' => 'home#javascript'
  root :to => 'home#index'
end
