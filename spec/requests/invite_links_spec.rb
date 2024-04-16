require 'rails_helper'

RSpec.describe "/invite_links", type: :request do
  let(:team) { create(:team) }
  let(:user) { team.captain }
  let(:different_user) { create(:user) }
  let(:invite_link) { create(:invite_link, team:, user:) }

  before do
    sign_in_as(user)
  end

  describe "GET /index" do
    it "renders a successful response" do
      get team_invite_links_url(team)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "redirects to code if logged in as link creator" do
      get team_invite_link_url(team, invite_link)
      expect(response).to redirect_to(join_team_invite_link_path(invite_link.code))
    end

    it "does not redirect to code if logged in as someone else" do
      sign_in_as(create(:user))
      get team_invite_link_url(team, invite_link)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_team_invite_link_url(team)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_team_invite_link_url(team, invite_link)
      expect(response).to be_successful
    end
  end

  describe "GET /join" do
    before do
      sign_in_as(different_user)
    end

    it "renders a successful response" do
      get join_team_invite_link_path(invite_link.code)
      expect(response).to be_successful
    end

    it "renders a failure response if expired" do
      old = create(:invite_link, team:, user:, expires_at: 10.minutes.from_now)
      old.expires_at = 10.years.ago
      old.save

      get join_team_invite_link_path(old.code)
      expect(response).to have_http_status(302)
    end
  end

  describe "POST /join" do
    before do
      sign_in_as(different_user)
    end

    it "adds current user to the members on that team" do
      expect do
        post join_team_invite_link_path(invite_link.code)
      end.to change { team.reload.members.count }.by(1)
    end

    it "should decrement the remaining spaces on the link" do
      expect do
        post join_team_invite_link_path(invite_link.code)
      end.to change { invite_link.reload.spaces_remaining }.by(-1)
    end

    context 'bad link' do
      it "not to add current user to the members on that team" do
        old = create(:invite_link, team:, user:)
        old.expires_at = 10.years.ago
        old.save

        expect do
          post join_team_invite_link_path(old.code)
        end.not_to change { team.reload.members.count }
      end

      it "should not decrement the remaining spaces on an expired link" do
        old = create(:invite_link, team:, user:)
        old.expires_at = 10.years.ago
        old.save

        expect do
          post join_team_invite_link_path(old.code)
        end.not_to change { old.reload.spaces_remaining }
      end

      it "should not decrement the remaining spaces on a link with no more spaces" do
        packed = create(:invite_link, team:, user:, spaces_remaining: 1)

        post join_team_invite_link_path(packed.code)

        expect do
          post join_team_invite_link_path(packed.code)
        end.not_to change { packed.reload.spaces_remaining }
      end

      it "renders a failure response if already joined" do
        sign_in_as(create(:user))
        post join_team_invite_link_path(invite_link.code)
        post join_team_invite_link_path(invite_link.code)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not decrement the remaining spaces on the link if already joined" do
        sign_in_as(create(:user))
        post join_team_invite_link_path(invite_link.code)

        expect do
          post join_team_invite_link_path(invite_link.code)
        end.not_to change { invite_link.reload.spaces_remaining }
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new InviteLink" do
        expect {
          post team_invite_links_url(team), params: { invite_link: attributes_for(:invite_link) }
        }.to change(InviteLink, :count).by(1)
      end

      it "redirects to the created invite_link" do
        post team_invite_links_url(team), params: { invite_link: attributes_for(:invite_link) }
        expect(response).to redirect_to(team_invite_link_url(team, InviteLink.last))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attrs) { { **attributes_for(:invite_link).slice(:expires_at), spaces_remaining: -1 } }

      it "does not create a new InviteLink" do
        expect {
          post team_invite_links_url(team), params: { invite_link: invalid_attrs }
        }.to change(InviteLink, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post team_invite_links_url(team), params: { invite_link: invalid_attrs }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        attributes_for(:invite_link)
      }

      it "updates the requested invite_link" do
        expect do
          patch team_invite_link_url(team, invite_link), params: { invite_link: attributes_for(:invite_link) }
        end.to change { invite_link.reload.expires_at }
      end

      it "redirects to the invite_link" do
        patch team_invite_link_url(team, invite_link), params: { invite_link: attributes_for(:invite_link) }
        expect(response).to redirect_to(team_url(team))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        invalid_attrs = { **attributes_for(:invite_link).slice(:expires_at), spaces_remaining: -1 }
        patch team_invite_link_url(team, invite_link), params: { invite_link: invalid_attrs }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested invite_link" do
      invite_link.save
      expect {
        delete team_invite_link_url(team, invite_link)
      }.to change(InviteLink, :count).by(-1)
    end

    it "redirects to the invite_links list" do
      delete team_invite_link_url(team, invite_link)
      expect(response).to redirect_to(team_invite_links_url(team))
    end
  end
end