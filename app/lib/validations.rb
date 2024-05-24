# frozen_string_literal: true

module Validations
  delegate :to_h, :errors, to: :result

  alias_method :validated_params, :to_h

  def validate(params)
    @result = schema.call(params.to_h)
    result.success? ? Success(result.to_h) : Failure([__callee__, result.errors(full: true)])
  end

  def schema
    raise NotImplementedError
  end

  private

  attr_reader :result
end
