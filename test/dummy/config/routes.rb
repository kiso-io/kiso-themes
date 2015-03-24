Dummy::Application.routes.draw do
  devise_for :users

  get '/kitchen_sink' => 'home#kitchen_sink'
  get '/css' => 'home#css'
  get '/components' => 'home#components'
  get '/javascript' => 'home#javascript'

  get 'preview/main' => 'preview#main'
  get 'preview/:section' => 'preview#main', as: :element

  get 'styles/:style', to: 'preview#styles', as: :switch_style

  root :to => 'preview#index'
end
