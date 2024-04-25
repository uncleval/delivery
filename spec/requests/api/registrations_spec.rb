require "rails_helper"

RSpec.describe "registrations", type: :request do
  let(:credential) {
    Credential.create_access(:buyer)
  }

  describe "POST /new" do
    it "creates a buyer user" do
      post(
        create_registration_url,
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          user: {
            email: "admin_user@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      )
      user = User.find_by(email: "admin_user@example.com")

      expect(response).to be_successful
      expect(user).to be_buyer
    end

    it "fails when trying to create user without credentials" do
      post(
        create_registration_url,
        headers: {"Accept" => "application/json"},
        params: {
          user: {
            email: "admin_user@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      )

      expect(response).to be_unprocessable
    end
  end

  describe "post /sign_in" do
    before do
      User.create!(
        email: "seller@example.com",
        password: "123456",
        password_confirmation: "123456",
        role: :seller
      )
    end

    before do
      User.create!(
        email: "buyer@example.com",
        password: "123456",
        password_confirmation: "123456",
        role: :buyer
      )
    end

    it "prevents users with roles different from credentials do sign in" do
      post(
        "/sign_in",
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          login: {email: "seller@example.com", password: "123456"}
        }
      )

      expect(response).to be_unauthorized
    end

    it "allows for authentication when access and role are the same" do
      post(
        "/sign_in",
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          login: {email: "buyer@example.com", password: "123456"}
        }
      )

      expect(response).to be_successful
    end
  end
end
