# frozen_string_literal: true

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :doc

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.order = :random

  Kernel.srand config.seed

  config.after(:each, type: :request) do |example|
    if response.body.present?
      begin
        example.metadata[:response][:content] = {
          "application/json" => {
            examples: {
              example.metadata[:example_group][:description] => {
                value: JSON.parse(response.body, symbolize_names: true)
              }
            }
          }
        }
      rescue JSON::ParserError
        nil
      end
    end
  end
end
