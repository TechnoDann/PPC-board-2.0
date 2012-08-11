require 'spec_helper'

describe "bans/edit" do
  before(:each) do
    @ban = assign(:ban, stub_model(Ban,
      :user_id => 1,
      :ip => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit ban form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bans_path(@ban), :method => "post" do
      assert_select "input#ban_user_id", :name => "ban[user_id]"
      assert_select "input#ban_ip", :name => "ban[ip]"
      assert_select "input#ban_email", :name => "ban[email]"
    end
  end
end
