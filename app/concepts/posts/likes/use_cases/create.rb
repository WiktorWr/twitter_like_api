# frozen_string_literal: true

module Posts
  module Likes
    module UseCases
      class Create < Base
        def call
          yield validate(params)
          yield check_post_existence
          yield check_friendship_existence
          yield check_if_not_liked

          create_like!
        end

        private

        def check_if_not_liked
          return Success() if like.nil?

          error(I18n.t("errors.likes.already_exists"))
        end

        def create_like!
          like = Like.create!(user: current_user, likeable: post)

          Success(like)
        end

        # HELPER METHODS

        def schema
          ::Posts::Likes::Schemas::Create.new
        end
      end
    end
  end
end
