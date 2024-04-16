# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/invite_links' do
  let(:herd) { create(:herd) }
  let(:user) { herd.captain }
  let(:different_user) { create(:user) }
  let(:invite_link) { create(:invite_link, herd:, user:) }

  before do
    sign_in_as(user)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get herd_invite_links_url(herd)
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'redirects to code if logged in as link creator' do
      get herd_invite_link_url(herd, invite_link)
      expect(response).to redirect_to(join_herd_invite_link_path(invite_link.code))
    end

    it 'does not redirect to code if logged in as someone else' do
      sign_in_as(create(:user))
      get herd_invite_link_url(herd, invite_link)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_herd_invite_link_url(herd)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_herd_invite_link_url(herd, invite_link)
      expect(response).to be_successful
    end
  end

  describe 'GET /join' do
    before do
      sign_in_as(different_user)
    end

    it 'renders a successful response' do
      get join_herd_invite_link_path(invite_link.code)
      expect(response).to be_successful
    end

    it 'renders a failure response if expired' do
      old = create(:invite_link, herd:, user:, expires_at: 10.minutes.from_now)
      old.expires_at = 10.years.ago
      old.save

      get join_herd_invite_link_path(old.code)
      expect(response).to have_http_status(:found)
    end
  end

  describe 'POST /join' do
    before do
      sign_in_as(different_user)
    end

    it 'adds current user to the members on that herd' do
      expect do
        post join_herd_invite_link_path(invite_link.code)
      end.to change { herd.reload.members.count }.by(1)
    end

    it 'decrements the remaining spaces on the link' do
      expect do
        post join_herd_invite_link_path(invite_link.code)
      end.to change { invite_link.reload.spaces_remaining }.by(-1)
    end

    context 'when bad link' do
      it 'not to add current user to the members on that herd' do
        old = create(:invite_link, herd:, user:)
        old.expires_at = 10.years.ago
        old.save

        expect do
          post join_herd_invite_link_path(old.code)
        end.not_to(change { herd.reload.members.count })
      end

      it 'does not decrement the remaining spaces on an expired link' do
        old = create(:invite_link, herd:, user:)
        old.expires_at = 10.years.ago
        old.save

        expect do
          post join_herd_invite_link_path(old.code)
        end.not_to(change { old.reload.spaces_remaining })
      end

      it 'does not decrement the remaining spaces on a link with no more spaces' do
        packed = create(:invite_link, herd:, user:, spaces_remaining: 1)

        post join_herd_invite_link_path(packed.code)

        expect do
          post join_herd_invite_link_path(packed.code)
        end.not_to(change { packed.reload.spaces_remaining })
      end

      it 'renders a failure response if already joined' do
        sign_in_as(create(:user))
        post join_herd_invite_link_path(invite_link.code)
        post join_herd_invite_link_path(invite_link.code)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not decrement the remaining spaces on the link if already joined' do
        sign_in_as(create(:user))
        post join_herd_invite_link_path(invite_link.code)

        expect do
          post join_herd_invite_link_path(invite_link.code)
        end.not_to(change { invite_link.reload.spaces_remaining })
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new InviteLink' do
        expect do
          post herd_invite_links_url(herd), params: { invite_link: attributes_for(:invite_link) }
        end.to change(InviteLink, :count).by(1)
      end

      it 'redirects to the created invite_link' do
        post herd_invite_links_url(herd), params: { invite_link: attributes_for(:invite_link) }
        expect(response).to redirect_to(herd_invite_link_url(herd, InviteLink.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attrs) { { **attributes_for(:invite_link).slice(:expires_at), spaces_remaining: -1 } }

      it 'does not create a new InviteLink' do
        expect do
          post herd_invite_links_url(herd), params: { invite_link: invalid_attrs }
        end.not_to change(InviteLink, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post herd_invite_links_url(herd), params: { invite_link: invalid_attrs }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        attributes_for(:invite_link)
      end

      it 'updates the requested invite_link' do
        expect do
          patch herd_invite_link_url(herd, invite_link), params: { invite_link: attributes_for(:invite_link) }
        end.to(change { invite_link.reload.expires_at })
      end

      it 'redirects to the invite_link' do
        patch herd_invite_link_url(herd, invite_link), params: { invite_link: attributes_for(:invite_link) }
        expect(response).to redirect_to(herd_url(herd))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        invalid_attrs = { **attributes_for(:invite_link).slice(:expires_at), spaces_remaining: -1 }
        patch herd_invite_link_url(herd, invite_link), params: { invite_link: invalid_attrs }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested invite_link' do
      invite_link.save
      expect do
        delete herd_invite_link_url(herd, invite_link)
      end.to change(InviteLink, :count).by(-1)
    end

    it 'redirects to the invite_links list' do
      delete herd_invite_link_url(herd, invite_link)
      expect(response).to redirect_to(herd_invite_links_url(herd))
    end
  end
end
