require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /show" do
    it "returns http success" do
      sign_in_as(create(:user))
      get user_path(User.last)
      expect(response).to have_http_status(:success)
    end
  end
end
