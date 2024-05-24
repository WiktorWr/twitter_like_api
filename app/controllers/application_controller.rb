# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Dry::Monads[:result]
  include ApiError

  def prepared_params
    params.to_unsafe_h.deep_symbolize_keys
  end
end
