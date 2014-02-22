require 'spec_helper'

describe "Home page" do
  describe "GET /" do
    it "should load correctly" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit root_path
      expect(page).to have_content('Allabolag.se')
    end
    it "should have index link" do
      visit root_path
      expect(page).to have_link('Index', href: root_path)
    end
  end
  describe "Search" do
    before(:each) do
      @attributes = {:query => "Company AB", :result => "CMP"}
      Search.create(@attributes)
      visit root_path
    end
    it "should return a correct value for existing company"
      pending 'should test form submission and response'

    it "should return no results for a not in either database or on allabolag.se company"
      pending 'should test form submission and response'

  end
end
