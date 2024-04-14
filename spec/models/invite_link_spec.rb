require 'rails_helper'

RSpec.describe InviteLink, type: :model do
  it "should generate a code when created" do
    user = create(:user)
    team = create(:team, captain: user)
    invite = build(:invite_link, user: user, team: team)
    expect(invite).to be_valid

    expect do
      invite.save
    end.to change {invite.code}
  end
end
