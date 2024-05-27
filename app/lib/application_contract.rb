# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  EMAIL_FORMAT        = URI::MailTo::EMAIL_REGEXP
  PASSWORD_MIN_LENGTH = 8
  PASSWORD_FORMAT     = %r{(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^!?&*_\-+=<>|/()\[\]])}

  config.messages.load_paths << "config/locales/en.yml"
end
