# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you"re using the rswag-api to serve API descriptions, you"ll need
  # to ensure that it"s configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join("docs").to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the "rswag:specs:swaggerize" rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe "...", swagger_doc: "v2/swagger.json"
  config.swagger_docs = {
    "v1/swagger.yaml" => {
      openapi:    "3.0.1",
      info:       {
        title:   "twitter API",
        version: "v1"
      },
      paths:      {},
      servers:    [
        {
          url:       "",
          variables: {
            defaultHost: {
              default: Rails.application.credentials.dig(Rails.env.to_sym, :api_url).to_s
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          "Bearer Token": {
            description: "Access token necessary to use API calls",
            type:        :http,
            scheme:      :bearer,
            name:        :Authorization,
            in:          :header
          }
        },
        schemas:         {
          post:                  {
            type:       :object,
            properties: {
              id:         { type: :integer },
              text:       { type: :string },
              created_at: { type: :string, format: "date-time" }
            }
          },
          user:                  {
            type:       :object,
            properties: {
              id:         { type: :integer },
              first_name: { type: :string },
              last_name:  { type: :string },
              email:      { type: :string }
            }
          },
          friendship_invitation: {
            type:       :object,
            properties: {
              id:         { type: :integer },
              receiver:   { "$ref": "#/components/schemas/user" },
              sender:     { "$ref": "#/components/schemas/user" },
              created_at: { type: :string, format: "date-time" }
            }
          },
          message:               {
            type:       :object,
            properties: {
              id:         { type: :integer },
              text:       { type: :string },
              created_at: { type: :string, format: "date-time" },
              user:       { "$ref": "#/components/schemas/user" }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running "rswag:specs:swaggerize".
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ":json" and ":yaml".
  config.swagger_format = :yaml
end
