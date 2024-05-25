# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Dry::Monads[:result]
  include ApiError

  private

  def params_with_current_user
    [prepared_params, current_user]
  end

  def prepared_params
    params.to_unsafe_h.deep_symbolize_keys
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.try(:resource_owner_id))
  end
end
