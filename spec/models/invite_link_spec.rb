# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InviteLink do
  it 'generates a code when created' do
    user = create(:user)
    herd = create(:herd, captain: user)
    invite = build(:invite_link, code: nil, user:, herd:)
    expect(invite).to be_valid
    expect do
      invite.save
    end.to(change { invite.code })
  end

  describe '#join' do
    let(:user) { create(:user) }
    let(:herd) { create(:herd) }
    let(:invite_link) { create(:invite_link, user: user, herd: herd, spaces_remaining: 5) }

    it 'decrements remaining spaces by one' do
      expect do
        invite_link.join(user)
      end.to change { invite_link.reload.spaces_remaining }.by(-1)
    end

    it 'adds user to the herd' do
      invite_link.join(user)
      expect(herd.members).to include(user)
    end
  end
end
