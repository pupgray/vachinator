# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/herds' do
  let(:user) { create(:user) }
  let(:herd) { create(:herd, captain: user) }

  before do
    sign_in_as(user)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get herds_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get herd_url(herd)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_herd_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_herd_url(herd)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Herd' do
        expect do
          post herds_url, params: { herd: { name: "#{Faker::Team.name}0" } }
        end.to change(Herd, :count).by(1)
      end

      it 'not create a new Herd with special characters' do
        expect do
          post herds_url, params: { herd: { name: "#{Faker::Team.name}!!!!!!!" } }
        end.not_to change(Herd, :count)
      end

      it 'redirects to the created herd' do
        post herds_url, params: { herd: { name: "#{Faker::Team.name}1" } }
        expect(response).to redirect_to(herd_url(Herd.last))
      end
    end

    context 'with invalid parameters' do
      it 'not create a new Herd with special characters' do
        expect do
          post herds_url, params: { herd: { name: "#{Faker::Team.name}!!!!!!!" } }
        end.not_to change(Herd, :count)
      end

      it 'responds with 422 for bad params' do
        post herds_url, params: { herd: { name: "#{Faker::Team.name}!!!!!!!" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested herd' do
        patch herd_url(herd), params: { herd: { name: 'ailurus' } }
        herd.reload
        expect(herd.name).to eql('ailurus')
      end

      it 'does not update the requested herd if not currently logged in as the captain' do
        bad_herd = create(:herd)
        patch herd_url(bad_herd), params: { herd: { name: 'ailurus' } }
        herd.reload
        expect(herd.name).not_to eql('ailurus')
      end

      it 'redirects to the herd' do
        patch herd_url(herd), params: { herd: { name: 'ailurus' } }
        herd.reload
        expect(herd.name).to eql('ailurus')
        expect(response).to redirect_to(herd_url(herd))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested herd' do
      herd.save
      expect do
        delete herd_url(herd)
      end.to change(Herd, :count).by(-1)
    end

    it 'redirects to the herds list' do
      delete herd_url(herd)
      expect(response).to redirect_to(herds_url)
    end
  end
end
