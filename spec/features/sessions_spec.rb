require "rails_helper"

feature "Sessions" do
  let(:user) { create(:user) }

  context "while signed in" do
    scenario "signing out" do
      sign_in_as user

      click_on "Log out"
      assert_text "That session has been logged out"
    end

    scenario "managing devices" do
      sign_in_as user

      click_on "Devices & Sessions"
      assert_selector "h2", text: "Sessions"
    end
  end

  scenario "signing in" do
    visit sign_in_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    assert_text "Signed in successfully"
  end
end