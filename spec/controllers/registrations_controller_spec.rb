require "rails_helper"

RSpec.describe RegistrationsController do
  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new user and redirect to root url" do
      user = build(:user)

      expect {
        post :create, params: { username: user.username, email: user.email, password: user.password, password_confirmation: user.password }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_url)
    end
  end
end