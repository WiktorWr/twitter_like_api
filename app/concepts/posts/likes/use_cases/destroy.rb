# frozen_string_literal: true

module Posts
  module Likes
    module UseCases
      class Destroy < Base
        def call
          yield validate(params)
          yield check_post_existence
          yield check_friendship_existence
          yield check_if_liked

          destroy_like!
        end

        private

        def check_if_liked
          return Success() if like

          error(I18n.t("errors.likes.not_found"))
        end

        def destroy_like!
          like.destroy!

          Success()
        end

        # HELPER METHODS

        def schema
          ::Posts::Likes::Schemas::Destroy.new
        end
      end
    end
  end
end
