require "spec_helper"

describe BansController do
  describe "routing" do

    it "routes to #index" do
      get("/bans").should route_to("bans#index")
    end

    it "routes to #new" do
      get("/bans/new").should route_to("bans#new")
    end

    it "routes to #show" do
      get("/bans/1").should route_to("bans#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bans/1/edit").should route_to("bans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bans").should route_to("bans#create")
    end

    it "routes to #update" do
      put("/bans/1").should route_to("bans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bans/1").should route_to("bans#destroy", :id => "1")
    end

  end
end
