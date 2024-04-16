# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity::EmailVerificationsController do
  let(:user) { create(:user, :unverified) }

  before do
    sign_in_as user
  end

  describe 'POST #create' do
    it 'sends a verification email' do
      expect(UserMailer).to deliver_later(:email_verification, user:)

      post :create

      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET #show' do
    it 'verifies email' do
      sid = user.generate_token_for(:email_verification)

      get :show, params: { sid:, email: user.email }

      expect(response).to redirect_to(root_url)
    end

    it 'does not verify email with expired token' do
      sid = user.generate_token_for(:email_verification)

      travel_to 3.days.from_now

      get :show, params: { sid:, email: user.email }

      expect(response).to redirect_to(edit_identity_email_url)
      expect(flash[:alert]).to eq 'That email verification link is invalid'
    end
  end
end
