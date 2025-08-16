Rails.application.routes.draw do
  # Register Devise mapping without generating routes (helpers depend on mapping)
  devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        devise_for :users,
          path: "",
          path_names: { sign_in: "sign_in", sign_out: "sign_out", registration: "sign_up" },
          controllers: {
            sessions: "api/v1/auth/sessions",
            registrations: "api/v1/auth/registrations"
          }

        post "refresh", to: "tokens#refresh"
      end

      resources :recipes, only: [:index, :show]
      resources :messages, only: [:create, :index]
    end
  end
end
