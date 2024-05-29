# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationCable::Connection do
  let(:valid_address) { "/cable?token=#{user_tokens.token}" }

  context "when token is missing" do
    it "rejects connection" do
      expect { connect "/cable" }.to have_rejected_connection
    end
  end

  context "when token is revoked" do
    include_context "authorize_user"

    it "rejects connection" do
      user_tokens.update(revoked_at: DateTime.now)
      expect { connect valid_address }.to have_rejected_connection
    end
  end

  context "when token has expired" do
    include_context "authorize_user"

    it "rejects connection" do
      user_tokens.update(created_at: DateTime.now - 1.day, expires_in: 1)
      expect { connect valid_address }.to have_rejected_connection
    end
  end

  context "when everything is ok" do
    include_context "authorize_user"

    it "successfully connects" do
      connect valid_address
      expect(connection.current_user.id).to eq user.id
    end
  end
end
