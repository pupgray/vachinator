require 'rails_helper'

RSpec.describe "invite_links/index", type: :view do
  before(:each) do
    assign(:invite_links, [
      InviteLink.create!(),
      InviteLink.create!()
    ])
  end

  it "renders a list of invite_links" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
