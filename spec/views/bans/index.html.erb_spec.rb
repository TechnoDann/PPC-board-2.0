require 'spec_helper'

describe "bans/index" do
  before(:each) do
    assign(:bans, [
      stub_model(Ban,
        :user_id => 1,
        :ip => "Ip",
        :email => "Email"
      ),
      stub_model(Ban,
        :user_id => 1,
        :ip => "Ip",
        :email => "Email"
      )
    ])
  end

  it "renders a list of bans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Ip".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
