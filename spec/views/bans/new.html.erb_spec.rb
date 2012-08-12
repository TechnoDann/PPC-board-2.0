require 'spec_helper'

describe "bans/new" do
  before(:each) do
    assign(:ban, stub_model(Ban,
      :user_id => 1,
      :ip => "MyString",
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new ban form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bans_path, :method => "post" do
      assert_select "input#ban_user_id", :name => "ban[user_id]"
      assert_select "input#ban_ip", :name => "ban[ip]"
      assert_select "input#ban_email", :name => "ban[email]"
    end
  end
end
