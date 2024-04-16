# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordsController do
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
    it 'with valid params redirects to the root url' do
      patch :update,
            params: { password_challenge: user.password, password: user.password, password_confirmation: user.password }
      expect(response).to redirect_to(root_url)
    end

    it 'with invalid challenge does not update the password and returns an unprocessable entity response' do
      patch :update,
            params: { password_challenge: "#{user.password}!", password: user.password,
                      password_confirmation: user.password }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'with invalid confirmation does not update the password and returns an unprocessable entity response' do
      patch :update,
            params: { password_challenge: user.password, password: user.password,
                      password_confirmation: "#{user.password}!" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
