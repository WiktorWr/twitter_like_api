# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      use_doorkeeper do
        skip_controllers :authorizations, :applications, :authorized_applications
      end

      resources :posts, only: %i[create index]
    end
  end
end
