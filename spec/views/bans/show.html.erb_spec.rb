require 'spec_helper'

describe "bans/show" do
  before(:each) do
    @ban = assign(:ban, stub_model(Ban,
      :user_id => 1,
      :ip => "Ip",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Ip/)
    rendered.should match(/Email/)
  end
end
