# frozen_string_literal: true

module Users
  module UseCases
    class Index < ::Monads
      def call
        yield validate(params)

        fetch_users
      end

      private

      def fetch_users
        return Success(User.all) unless query = params_for(:filters, :query)

        users = ::Filter::ByQuery::Users.new(User.all, query).call

        Success(users)
      end

      # HELPER METHODS

      def schema
        ::Users::Schemas::Index.new
      end
    end
  end
end
