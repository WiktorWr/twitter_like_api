# frozen_string_literal: true

module UserNotifications
  module Services
    module Counter
      class Decrement < Base
        def call
          yield check_user_existence
          decrease_cached_value
          broadcast_value
        end

        private

        def decrease_cached_value
          if RedisStore.current.exists?(redis_key)
            current_value = RedisStore.current.get(redis_key).to_i
            new_value = [current_value - amount, 0].max.to_s

            RedisStore.current.set(redis_key, new_value)
          else
            RedisStore.current.set(redis_key, initial_count)
          end
        end
      end
    end
  end
end
