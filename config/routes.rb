Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication endpoints
      post 'login/event_organizer', to: 'authentication#login_event_organizer'
      post 'login/customer', to: 'authentication#login_customer'

      # Events CRUD endpoints
      resources :events

      # Bookings endpoints (only create and read are needed)
      resources :bookings, only: [:index, :show, :create]
    end
  end
end
