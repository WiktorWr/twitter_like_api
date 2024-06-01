# frozen_string_literal: true

module UserNotifications
  module Queries
    class Create
      class << self
        def call(notification_id, receiver_ids)
          query = <<-SQL.squish
          WITH new_user_notifications AS (
            INSERT INTO user_notifications (user_id, notification_id, seen, created_at, updated_at)
            SELECT
              user_id,
              #{notification_id} AS notification_id,
              false AS seen,
              NOW() AS created_at,
              NOW() AS updated_at
            FROM
              unnest(ARRAY[#{receiver_ids.join(',')}]) AS user_id
            RETURNING *
          )
          SELECT
            nun.id,
            nun.user_id,
            nun.notification_id,
            nun.seen,
            nun.created_at,
            n.text,
            n.post_id,
            n.friendship_invitation_id,
            n.notification_type
          FROM
            new_user_notifications nun
          JOIN
            notifications n ON nun.notification_id = n.id;
          SQL

          ActiveRecord::Base.connection.execute(ActiveRecord::Base.sanitize_sql(query))
        end
      end
    end
  end
end
