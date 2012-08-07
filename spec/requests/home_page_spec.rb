require 'spec_helper'

describe "Listsing threads" do
  describe "Home Page" do
    it "Should have the right top matter" do
      visit "/"
      page.should have_selector "head title", :text => "PPC Posting Board"
      page.should have_content "PPC Posting Board"
    end
  end
end
