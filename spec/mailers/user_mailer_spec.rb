require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { create(:user) }

  describe "password_reset" do
    let(:mail) {UserMailer.with(user: user).password_reset}

    it "renders the headers" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([user.email])
    end
  end

  describe "email_verification" do
    let(:mail) {UserMailer.with(user: user).email_verification}
    
    it "renders the headers" do
      expect(mail.subject).to eq("Verify your email")
      expect(mail.to).to eq([user.email])
    end
  end
end