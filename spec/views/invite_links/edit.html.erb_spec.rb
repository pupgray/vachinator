require 'rails_helper'

RSpec.describe "invite_links/edit", type: :view do
  let(:invite_link) {
    InviteLink.create!()
  }

  before(:each) do
    assign(:invite_link, invite_link)
  end

  it "renders the edit invite_link form" do
    render

    assert_select "form[action=?][method=?]", invite_link_path(invite_link), "post" do
    end
  end
end
