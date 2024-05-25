# frozen_string_literal: true

module Posts
  module UseCases
    class Create < ::Monads
      def call
        yield validate(params)

        create_post!
      end

      private

      def create_post!
        post = Post.create!(validated_params.merge(user: current_user))

        Success(post)
      end

      # HELPER METHODS

      def schema
        ::Posts::Schemas::Create.new
      end
    end
  end
end
