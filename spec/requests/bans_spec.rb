require 'spec_helper'

describe "Bans" do
  describe "GET /bans" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bans_path
      response.status.should be(200)
    end
  end
end
