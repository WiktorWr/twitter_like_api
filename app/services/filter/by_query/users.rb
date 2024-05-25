# frozen_string_literal: true

module Filter
  module ByQuery
    class Users < Base
      def search_query_fields
        @search_query_fields ||= %w(
          first_name
          last_name
        )
      end
    end
  end
end
