Rails.application.routes.draw do
  resources :responders,  only: [:index, :create]
end
