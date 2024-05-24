# frozen_string_literal: true

module ApiError
  def error!(code, error, http_code)
    render json: { error: error_message(code, error) }, status: http_code
  end

  private

  def error_message(code, error)
    {
      code:,
      details: parse_error(error)
    }
  end

  def parse_error(error)
    if params_validation_error?(error)
      parse_validation_errors(error)
    else
      parse_monad_errors(error)
    end
  end

  def parse_validation_errors(parameter_errors)
    return nil unless parameter_errors

    parameter_errors.map do |error|
      {
        key:     prepare_key(error.path),
        message: error.text
      }
    end
  end

  def parse_monad_errors(error)
    error.map do |e|
      {
        key:     e[:key] || "_base",
        message: e[:message]
      }
    end
  end

  def params_validation_error?(error)
    error.is_a?(Dry::Validation::MessageSet)
  end

  def validation_error_description
    I18n.t("errors.common.invalid_parameters")
  end

  def prepare_key(error_path)
    error_path.reduce("") do |memo, path|
      str = if path.is_a?(Integer)
              "[#{path}]"
            elsif path.is_a?(Symbol) && memo.empty?
              path.to_s
            else
              ".#{path}"
            end

      memo.dup << str
    end
  end
end
