require 'rails_helper'

RSpec.describe Identity::EmailsController do
  let(:user) { create(:user) }

  before do
    sign_in_as user
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    it 'updates the email' do
      patch :update, params: { email: user.email, password_challenge: user.password }
      expect(response).to redirect_to(root_url)
    end

    it 'does not update email with wrong password challenge' do
      patch :update, params: { email: user.email, password_challenge: user.password + '!' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end