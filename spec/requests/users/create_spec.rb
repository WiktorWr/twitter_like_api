# frozen_string_literal: true

require "swagger_helper"

describe "Users API" do
  path "/api/v1/users" do
    post "Create user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          first_name: { type: :string },
          last_name:  { type: :string },
          email:      { type: :string },
          password:   { type: :string, description: "min. 8 characters, min. one capital letter, min. one digit, min. one special character" }
        }
      }

      include_context "authorize_user"

      let(:params) do
        {
          first_name: Faker::Name.first_name,
          last_name:  Faker::Name.last_name,
          email:      Faker::Internet.unique.email,
          password:   "Password100!"
        }
      end

      response "201", "create user" do
        context "when email does not exists" do
          run_test!
        end

        # I don't want to expose information whether an account exists
        context "when email exists" do
          before do
            create(:user, email: params[:email])
          end

          run_test!
        end
      end

      response "422", "invalid params" do
        let!(:params) { {} }

        run_test!
      end
    end
  end
end
