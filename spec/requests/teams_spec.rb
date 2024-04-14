require 'rails_helper'

RSpec.describe "/teams", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team, captain: user) }

  before do
    sign_in_as(user)
  end

  describe "GET /index" do
    it "renders a successful response" do
      get teams_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get team_url(team)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_team_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_team_url(team)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Team" do
        expect {
          post teams_url, params: { team: { name: Faker::Team.name + "0" } }
        }.to change(Team, :count).by(1)
      end

      it "not create a new Team with special characters" do
        expect {
          post teams_url, params: { team: { name: Faker::Team.name + "!!!!!!!" } }
        }.not_to change(Team, :count)
      end

      it "redirects to the created team" do
        post teams_url, params: { team: { name: Faker::Team.name + "1" } }
        expect(response).to redirect_to(team_url(Team.last))
      end
    end

    context "with invalid parameters" do

      it "not create a new Team with special characters" do
        expect {
          post teams_url, params: { team: { name: Faker::Team.name + "!!!!!!!" } }
        }.not_to change(Team, :count)
      end

      it "responds with 422 for bad params" do
        post teams_url, params: { team: { name: Faker::Team.name + "!!!!!!!" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested team" do
        patch team_url(team), params: { team: { name: 'ailurus' } }
        team.reload
        expect(team.name).to eql('ailurus')
      end

      it "does not update the requested team if not currently logged in as the captain" do
        bad_team = create(:team)
        patch team_url(bad_team), params: { team: { name: 'ailurus' } }
        team.reload
        expect(team.name).not_to eql('ailurus')
      end

      it "redirects to the team" do
        patch team_url(team), params: { team: { name: 'ailurus' } }
        team.reload
        expect(team.name).to eql('ailurus')
        expect(response).to redirect_to(team_url(team))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested team" do
      team.save
      expect {
        delete team_url(team)
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      delete team_url(team)
      expect(response).to redirect_to(teams_url)
    end
  end
end
