require 'spec_helper'

describe "Pages" do
  describe "public access" do
    it "returns home page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pages_home_path
      response.status.should be(200)
    end
    
    it "returns about page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pages_about_path
      response.status.should be(200)
    end
    
    it "returns help page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pages_help_path
      response.status.should be(200)
    end
    
    it "returns contact page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get pages_contact_path
      response.status.should be(200)
    end
  end
end
