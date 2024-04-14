require "rails_helper"

feature "Registrations" do
  scenario "signing up" do
    visit sign_up_url

    user = build(:user)

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_on "Sign up"

    assert_text "Welcome! You have signed up successfully"

    click_on "Log out"
    click_on "Sign in"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "Signed in successfully"
  end
end
