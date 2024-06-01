# frozen_string_literal: true

module UserNotifications
  module Services
    module Counter
      class Base < ::Monads
        def initialize(user_id, amount = 1)
          @user_id = user_id
          @amount = amount

          super
        end

        private

        attr_reader :user_id, :amount

        def check_user_existence
          return Success() if User.exists?(id: user_id)

          error(I18n.t("errors.users.not_found"))
        end

        def broadcast_value
          ActionCable.server.broadcast(
            "user_notifications_counter_channel_#{user_id}",
            { count: RedisStore.current.get(redis_key) }
          )

          Success()
        end

        # HELPER METHODS

        def initial_count
          UserNotification.where(user_id:, seen: false).size
        end

        def redis_key
          "user_#{user_id}_notifications_count"
        end
      end
    end
  end
end
