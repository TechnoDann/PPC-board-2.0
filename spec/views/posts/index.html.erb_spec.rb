require 'spec_helper'

describe "posts/index" do
  before(:each) do
    assign(:posts, [
      stub_model(Post,
        :parent_id => 1,
        :lft => 2,
        :rgt => 3,
        :locked => false,
        :poofed => false,
        :subject => "Subject",
        :user_id => 4,
        :author => "Author",
        :body => "MyText"
      ),
      stub_model(Post,
        :parent_id => 1,
        :lft => 2,
        :rgt => 3,
        :locked => false,
        :poofed => false,
        :subject => "Subject",
        :user_id => 4,
        :author => "Author",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of posts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
