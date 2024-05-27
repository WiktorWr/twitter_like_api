# frozen_string_literal: true

module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :delete_all
  end
end
