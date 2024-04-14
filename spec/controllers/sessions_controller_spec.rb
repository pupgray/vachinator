require 'rails_helper'

RSpec.describe SessionsController do
  let(:user) { create(:user) }

  it 'should get index' do
    sign_in_as user
    get :index
    expect(response).to have_http_status(:success)
  end

  it 'should get new' do
    get :new
    expect(response).to have_http_status(:success)
  end

  it 'should sign in' do
    post :create, params: { email: user.email, password: user.password }
    expect(response).to redirect_to(root_path)
  end

  it 'should sign out' do
    sign_in_as user
    session = user.sessions.last
    delete :destroy, params: { id: session.id }
    expect(response).to redirect_to(action: :index)
  end

  context 'wrong credentials' do
    before do
      post :create, params: { email: user.email, password: user.password + '!' }
    end

    it 'should not sign in' do
      expect(response).to redirect_to(action: :new, params: { email_hint: user.email })
    end

    it 'should show a flash message' do
      expect(flash['alert']).to match(/That email or password is incorrect/)
    end
  end
end