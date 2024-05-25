# frozen_string_literal: true

RSpec.shared_context "authorize_user" do
  let!(:user) { create(:user) }

  let!(:user_tokens) do
    Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      expires_in:        Doorkeeper.configuration.access_token_expires_in.to_i
    )
  end

  let(:Authorization) { "Bearer #{user_tokens.token}" }
end
