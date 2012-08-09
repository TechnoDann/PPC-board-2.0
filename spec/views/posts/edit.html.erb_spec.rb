require 'spec_helper'

describe "posts/edit" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :parent_id => 1,
      :lft => 1,
      :rgt => 1,
      :locked => false,
      :poofed => false,
      :subject => "MyString",
      :user_id => 1,
      :author => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_parent_id", :name => "post[parent_id]"
      assert_select "input#post_lft", :name => "post[lft]"
      assert_select "input#post_rgt", :name => "post[rgt]"
      assert_select "input#post_locked", :name => "post[locked]"
      assert_select "input#post_poofed", :name => "post[poofed]"
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "input#post_user_id", :name => "post[user_id]"
      assert_select "input#post_author", :name => "post[author]"
      assert_select "textarea#post_body", :name => "post[body]"
    end
  end
end
