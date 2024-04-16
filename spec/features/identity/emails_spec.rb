# frozen_string_literal: true

require 'rails_helper'

describe 'Emails' do
  let(:user) { create(:user) }

  before do
    sign_in_as user
    visit identity_settings_path
  end

  it 'changing your email address' do
    expect(user.reload).to be_verified

    await_mailing do
      click_on 'Change email address'

      fill_in 'New email', with: "new_#{user.email}"
      fill_in 'Password challenge', with: user.password
      click_on 'Save changes'

      assert_text 'Your email has been changed'
    end

    expect(user.reload).not_to be_verified

    visit find_mail_to(user.email).find_link_url('Yes, use this email for my account')

    assert_text 'Thank you for verifying your email address'

    expect(user.reload).to be_verified
  end

  it 'resend the verification email' do
    user.verified = false
    user.save

    await_mailing do
      click_on 'Change email address'
      click_on 'Re-send verification email'
    end

    assert_text 'We sent a verification email to your email address'

    visit find_mail_to(user.email).find_link_url('Yes, use this email for my account')

    assert_text 'Thank you for verifying your email address'

    expect(user.reload).to be_verified
  end
end
