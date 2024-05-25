# frozen_string_literal: true

module Users
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :first_name,
                     :last_name,
                     :email
    end
  end
end
