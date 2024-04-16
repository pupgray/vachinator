# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  it 'is not valid without a username' do
    bad_user = build(:user, username: nil)
    expect(bad_user).not_to be_valid
  end

  it 'is not valid without a unique username' do
    user.save
    bad_user = build(:user, username: user.username)
    expect(bad_user).not_to be_valid
  end

  it 'is not valid without an email' do
    user.email = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without a unique email' do
    user.save
    bad_user = build(:user, email: user.email)
    expect(bad_user).not_to be_valid
  end

  it 'is not valid without an password of minimum length' do
    user.password = '123'
    expect(user).not_to be_valid
  end
end
