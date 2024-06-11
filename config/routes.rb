# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      use_doorkeeper do
        skip_controllers :authorizations, :applications, :authorized_applications
      end

      resources :users, only: %i[create index] do
        member do
          get :unread_notifications_count
        end
      end
      resources :posts, only: %i[create index] do
        member do
          resource :likes, only: %i[create destroy], controller: :post_likes
        end
      end
      resources :friendship_invitations, only: %i[create] do
        member do
          post :accept
          post :reject
        end
      end
      resources :chats, only: %i[] do
        member do
          resources :messages, only: %i[create index]
        end
      end
      resources :user_notifications, only: %i[index] do
        collection do
          post :read
          post :read_all
        end
      end
    end
  end
end
