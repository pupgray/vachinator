require 'rails_helper'

RSpec.describe "invite_links/new", type: :view do
  before(:each) do
    assign(:invite_link, InviteLink.new())
  end

  it "renders new invite_link form" do
    render

    assert_select "form[action=?][method=?]", team_invite_links_path, "post" do
    end
  end
end
