# frozen_string_literal: true

require "pagy_cursor/pagy/extras/cursor"

module Pagination
  include Pagy::Backend

  def cursor_paginate(collection, prepared_params)
    pagy_cursor(collection, before: cursor(prepared_params), order: { created_at: :desc })
  end

  def cursor(prepared_params)
    prepared_params[:oldest_item_id].presence
  end
end
