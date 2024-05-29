# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = connected_user
    end

    private

    def fetch_user_from_token
      token = request.params["token"]
      return reject_unauthorized_connection unless token

      access_token = Doorkeeper::AccessToken.find_by(active_token_sql(token))
      return reject_unauthorized_connection unless access_token

      user = User.find_by(id: access_token[:resource_owner_id])
      return reject_unauthorized_connection unless user

      user
    end

    def connected_user
      @connected_user ||= fetch_user_from_token
    end

    def active_token_sql(token)
      ActiveRecord::Base.sanitize_sql(
        ["token = ? and revoked_at IS NULL and created_at > (now() - (expires_in || ' seconds')::interval)", token]
      )
    end
  end
end
