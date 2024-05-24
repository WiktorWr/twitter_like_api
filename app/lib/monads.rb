# frozen_string_literal: true

require "dry/monads"

class Monads
  include Dry::Monads[:result, :do]
  include Validations

  def initialize(params = nil, current_user = nil)
    @params       = params
    @current_user = current_user
  end

  private

  attr_reader :current_user, :params

  def params_for(*params_path)
    param = validated_params.dig(*params_path)

    if param == false
      false
    else
      param.presence
    end
  end

  def authorize
    return error(I18n.t("errors.common.access_forbidden")) unless policy

    Success()
  end

  def error(message, key = nil)
    method_name = if caller(4..4).first.exclude? "rescue"
                    caller(4..4).first[/`([^']+)'/][1..-2]
                  else
                    caller(5..5).first[/`([^']+)'/][1..-2]
                  end

    Failure[
      method_name.to_sym,
      [{ key:, message: }]
    ]
  end
end
