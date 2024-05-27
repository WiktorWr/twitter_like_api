# frozen_string_literal: true

module Posts
  module Likes
    module UseCases
      class Base < ::Monads
        private

        def check_post_existence
          return Success() if post

          error(I18n.t("errors.posts.not_found"))
        end

        def check_friendship_existence
          return Success() if friendship_exists?

          error(I18n.t("errors.friendships.not_found"))
        end

        # HELPER METHODS

        def post
          @post ||= Post.includes(:user)
                        .find_by(id: validated_params[:id])
        end

        def friendship_exists?
          Friendship.exists?(user: current_user, friend: post.user) &&
            Friendship.exists?(user: post.user, friend: current_user)
        end

        def like
          Like.find_by(user: current_user, likeable: post)
        end
      end
    end
  end
end
