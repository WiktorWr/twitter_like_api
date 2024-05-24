# frozen_string_literal: true

RSpec.shared_examples "schema validation failure" do |expected_messages|
  it "contains validation errors" do
    messages = subject.failure[1].messages

    parsed_messages = messages.map(&:text)

    expect(parsed_messages).to match_array(expected_messages)
  end
end
