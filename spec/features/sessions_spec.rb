# frozen_string_literal: true

require 'rails_helper'

describe 'Sessions' do
  let(:user) { create(:user) }

  context 'when signed in' do
    it 'signing out' do
      sign_in_as user

      visit identity_settings_path

      click_on 'Log out'
      assert_text 'That session has been logged out'
    end

    it 'managing devices' do
      sign_in_as user

      visit identity_settings_path

      click_on 'Devices & Sessions'
      assert_selector 'h2', text: 'Sessions'
    end
  end

  it 'signing in' do
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    assert_text 'Signed in successfully'
  end
end
