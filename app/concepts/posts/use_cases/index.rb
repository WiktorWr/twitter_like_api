# frozen_string_literal: true

module Posts
  module UseCases
    class Index < ::Monads
      def call
        yield validate(params)

        fetch_posts
      end

      private

      def fetch_posts
        return Success(Post.all) unless user_id = params_for(:filters, :user_id)

        Success(Post.where(user_id:))
      end

      # HELPER METHODS

      def schema
        ::Posts::Schemas::Index.new
      end
    end
  end
end
