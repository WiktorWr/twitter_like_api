# frozen_string_literal: true

module Filter
  module ByQuery
    class Base
      attr_reader :records, :values

      def initialize(records, query)
        @records = records
        @values  = sanitize_values(query.split)
      end

      def call
        records.where(full_text_query)
      end

      private

      def sanitize_values(values)
        values.map { |v| "%#{I18n.transliterate(v)}%" }
      end

      def full_text_query
        values
          .map { |v| search_query_for_all_fields_by(v) }
          .join("AND ")
      end

      def search_query_for_all_fields_by(value)
        "concat_ws(' ', #{search_query_fields.join(', ')} ) ILIKE '#{value}' "
      end
    end
  end
end
