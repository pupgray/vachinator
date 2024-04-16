# frozen_string_literal: true

require 'rails_helper'

describe 'Passwords' do
  let(:user) { create(:user) }

  before do
    sign_in_as user
  end

  it 'updating your password' do
    new_password = "#{user.password}!"

    click_on 'Change password'
    fill_in 'Password challenge', with: user.password
    fill_in 'New password', with: new_password
    fill_in 'Confirm new password', with: new_password
    click_on 'Save changes'

    expect(page).to have_content 'Your password has been changed'

    click_on 'Log out'
    click_on 'Sign in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully'
  end
end
