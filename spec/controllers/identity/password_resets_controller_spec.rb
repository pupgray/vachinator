# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity::PasswordResetsController do
  let(:user) { create(:user) }

  it 'gets new' do
    get :new
    expect(response).to have_http_status(:success)
  end

  it 'gets edit' do
    sid = user.generate_token_for(:password_reset)
    get :edit, params: { sid: }
    expect(response).to have_http_status(:success)
  end

  it 'sends a password reset email' do
    expect(UserMailer).to deliver_later(:password_reset, user:)

    post :create, params: { email: user.email }

    expect(response).to redirect_to(sign_in_url)
  end

  it 'does not send a password reset email to a nonexistent email' do
    expect(UserMailer).not_to deliver_later :password_reset

    post :create, params: { email: "invalid_#{user.email}" }

    expect(response).to redirect_to(new_identity_password_reset_url)
    expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
  end

  it 'does not send a password reset email to a unverified email' do
    unverified_user = create(:user, :unverified)
    expect(UserMailer).not_to deliver_later :password_reset

    post :create, params: { email: unverified_user.email }

    expect(response).to redirect_to(action: :new)
    expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
  end

  it 'updates password' do
    sid = user.generate_token_for(:password_reset)
    patch :update, params: { sid:, password: 'Secret6*4*2*', password_confirmation: 'Secret6*4*2*' }
    expect(response).to redirect_to(sign_in_url)
  end

  it 'does not update password with expired token' do
    sid = user.generate_token_for(:password_reset)
    travel 30.minutes
    patch :update, params: { sid:, password: 'Secret6*4*2*', password_confirmation: 'Secret6*4*2*' }
    expect(response).to redirect_to(action: :new)
    expect(flash[:alert]).to eq('That password reset link is invalid')
  end

  it "does not update password if passwords don't match" do
    sid = user.generate_token_for(:password_reset)
    patch :update, params: { sid:, password: 'Secret6*4*2*', password_confirmation: 'ailurus' }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
