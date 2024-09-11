Rails.application.routes.draw do
  root 'feed#show'

  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
