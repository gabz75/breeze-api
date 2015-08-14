Rails.application.routes.draw do

  namespace :v1 do
    resources :users, only: [] do
      resources :items, only: [:create]
    end
  end

end