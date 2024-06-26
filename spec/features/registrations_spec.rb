# frozen_string_literal: true

require 'rails_helper'

describe 'Registrations' do
  it 'signing up' do
    visit sign_up_url

    user = build(:user)

    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    assert_text 'Moo! You have signed up successfully'

    click_on 'Log out'
    click_on 'Sign in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully'
  end
end
