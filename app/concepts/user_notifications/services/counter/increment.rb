# frozen_string_literal: true

module UserNotifications
  module Services
    module Counter
      class Increment < Base
        def call
          yield check_user_existence
          increase_cached_value!
          broadcast_value
        end

        private

        def increase_cached_value!
          if RedisStore.current.exists?(redis_key)
            RedisStore.current.incr(redis_key)
          else
            RedisStore.current.set(redis_key, initial_count)
          end
        end
      end
    end
  end
end
