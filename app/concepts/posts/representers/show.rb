# frozen_string_literal: true

module Posts
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :text,
                     :created_at
    end
  end
end
