Rails.application.routes.draw do

  get "user_menus/index"

  mount InitEventTaskx::Engine => "/init_event_taskx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
