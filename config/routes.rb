Rails.application.routes.draw do
  resources :responders,  only: [:index, :create]
  get '/responders/:name', to: 'responders#show'
  patch '/responders/:name', to: 'responders#update'
end
