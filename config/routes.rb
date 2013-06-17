Baseproject::Application.routes.draw do

  root :to => "home#index"

  match "form" => "form#index"
  match "buttons" => "buttons#index"
  match "tabs" => "tabs#index"

  resources :films

end
