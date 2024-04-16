# frozen_string_literal: true

require 'rails_helper'

describe 'Herd Management' do
  let(:user) { create(:user) }
  let(:herd_name) { Faker::Team.name }

  before do
    sign_in_as user

    visit herds_path

    click_on 'New herd'
    fill_in 'Name', with: herd_name
    click_on 'Create Herd'

    assert_text 'Herd was successfully created.'
  end

  it 'creating a new herd' do
    visit herds_path

    assert_text herd_name
  end

  it 'creating a new invite link' do
    visit herd_invite_links_path(Herd.last.id)

    click_on 'New invite link'

    fill_in 'Expires At', with: 40.days.from_now
    fill_in 'Spaces Remaining', with: 100

    click_on 'Create Invite link'

    assert_text "Join #{herd_name}"
    assert_text "You were invited by #{user.username}. Remaining: 100 spaces"
  end
end
