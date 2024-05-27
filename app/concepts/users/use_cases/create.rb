# frozen_string_literal: true

module Users
  module UseCases
    class Create < ::Monads
      def call
        yield validate(params)
        yield check_email_existence

        create_user!
      end

      private

      def check_email_existence
        return Success() unless email_exists?

        error(I18n.t("errors.users.email_exists"))
      end

      def create_user!
        user = User.create!(validated_params)

        Success(user)
      end

      # HELPER METHODS

      def schema
        ::Users::Schemas::Create.new
      end

      def email_exists?
        User.exists?(email: validated_params[:email])
      end
    end
  end
end
