# frozen_string_literal: true

module Authentication
  module UseCases
    class SignIn < ::Monads
      def call
        yield validate(params)
        yield authenticate

        Success(resource)
      end

      def authenticate
        return Success() if resource&.authenticate(validated_params[:password])

        error(I18n.t("errors.sessions.authentication"))
      end

      # HELPER METHODS

      def schema
        ::Authentication::Schemas::SignIn.new
      end

      def resource
        @resource ||= User.find_by(email: validated_params[:email])
      end
    end
  end
end
