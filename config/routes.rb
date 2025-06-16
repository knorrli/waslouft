Rails.application.routes.draw do
  resources :tag_groups
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'events#index'

  resource :session

  resources :events, only: [:index, :destroy]
  resources :tags, only: :index

  get 'calendar', to: 'calendars#show'

  scope 'tests' do
    get ':name', to: 'tests#show'
  end

  scope :admin do
    get '', to: 'admin#index', as: :admin
    post 'scrape_events', to: 'admin#scrape_events', as: :scrape_events
    post 'clear_events', to: 'admin#clear_events', as: :clear_events
  end
end
