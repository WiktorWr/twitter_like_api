# frozen_string_literal: true

require "swagger_helper"

describe "Friendship invitations API" do
  path "/api/v1/friendship_invitations/{id}/accept" do
    post "Accept friendship invitation" do
      tags "Friendship Invitations"
      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true

      security ["Bearer Token": []]

      include_context "authorize_user"

      let!(:other_user) { create(:user) }
      let!(:invitation) { create(:friendship_invitation, sender: other_user, receiver: user) }
      let!(:id)         { invitation.id }

      response "200", "accept friendship invitation" do
        schema type:  :object,
               allOf: [{ "$ref": "#/components/schemas/friendship_invitation" }]

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end

      response "422", "invalid params" do
        let!(:id) { -1 }

        run_test!
      end

      response "404", "not found" do
        let!(:id) { invitation.id + 1 }

        run_test!
      end

      response "403", "forbidden" do
        let!(:invitation) { create(:friendship_invitation, sender: user, receiver: other_user) }

        run_test!
      end

      response "409", "conflict" do
        before do
          invitation.accept
        end

        run_test!
      end
    end
  end
end
