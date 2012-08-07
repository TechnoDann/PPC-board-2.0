require 'spec_helper'

describe "posts/show" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :parent_id => 1,
      :lft => 2,
      :rgt => 3,
      :locked => false,
      :poofed => false,
      :subject => "Subject",
      :user_id => 4,
      :author => "Author",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/Subject/)
    rendered.should match(/4/)
    rendered.should match(/Author/)
    rendered.should match(/MyText/)
  end
end
