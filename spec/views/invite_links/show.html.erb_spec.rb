require 'rails_helper'

RSpec.describe "invite_links/show", type: :view do
  before(:each) do
    assign(:invite_link, InviteLink.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
