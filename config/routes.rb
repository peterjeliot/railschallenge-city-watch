Rails.application.routes.draw do
  resources :responders, only: [:index, :create]
  get '/responders/:name', to: 'responders#show'
  patch '/responders/:name', to: 'responders#update'

  resources :emergencies, only: [:index, :create]
  get '/emergencies/:code', to: 'emergencies#show'
  patch '/emergencies/:code', to: 'emergencies#update'

  match '*path', to: 'application#routing_error', via: [:get, :post, :patch, :delete]
end
