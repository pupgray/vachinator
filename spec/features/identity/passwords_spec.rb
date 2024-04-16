# frozen_string_literal: true

require 'rails_helper'

describe 'Emails' do
  let(:user) { create(:user) }

  before do
    sign_in_as user
  end

  it 'reset your password' do
    await_mailing do
      visit sign_in_url
      click_on 'Forgot your password?'
      fill_in 'Email', with: user.email
      click_on 'Send password reset email'
      assert_text 'Check your email for reset instructions'
    end

    visit find_mail_to(user.email).find_link_url('Reset my password')

    expect do
      fill_in 'New password', with: "#{user.password}!"
      fill_in 'Confirm new password', with: "#{user.password}!"
      click_on 'Save changes'
    end.to(change { user.reload.password_digest })
  end
end
