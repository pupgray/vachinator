# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  let(:user) { create(:user) }

  it 'gets index' do
    sign_in_as user
    get :index
    expect(response).to have_http_status(:success)
  end

  it 'gets new' do
    get :new
    expect(response).to have_http_status(:success)
  end

  it 'signs in' do
    post :create, params: { email: user.email, password: user.password }
    expect(response).to redirect_to(root_path)
  end

  it 'signs out' do
    sign_in_as user
    session = user.sessions.last
    delete :destroy, params: { id: session.id }
    expect(response).to redirect_to(action: :index)
  end

  context 'with wrong credentials' do
    before do
      post :create, params: { email: user.email, password: "#{user.password}!" }
    end

    it 'does not sign in' do
      expect(response).to redirect_to(action: :new, params: { email_hint: user.email })
    end

    it 'shows a flash message' do
      expect(flash['alert']).to match(/That email or password is incorrect/)
    end
  end
end
