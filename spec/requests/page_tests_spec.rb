require 'spec_helper'
describe 'Home page' do
  describe 'GET /' do
    it 'should load correctly' do
      visit root_path
      expect(page).to have_content('Allabolag.se')
    end
    it 'should have index link' do
      visit root_path
      expect(page).to have_link('Index', href: root_path)
    end
  end

end

describe 'Search' do
  before(:each) do
    @attributes = {:company_name => 'Google Sweden AB', :org_number => '556656-6880'}
    Search.create(@attributes)
    visit root_path
  end
  # VCR not needed, since company is already created in database no remote lookup will take place
  it 'should return a correct value for existing company' do
    fill_in 'company_name', with: @attributes[:company_name]
    click_button 'Search'
    page.should have_content(@attributes[:org_number])
  end
  # VCR, since it does not exist in db a remote lookup will be used
  it 'should return no results for a not in either database or on allabolag.se company' do
    VCR.use_cassette("no_company_page_test") do
      fill_in 'company_name', with: 'notavalidcompany'
      click_button 'Search'
      page.should have_content('No results')
    end
  end
  # VCR not needed, since company is already created in database no remote lookup will take place
  it 'should return a json result' do
    fill_in 'company_name', with: @attributes[:company_name]
    #noinspection RubyArgCount
    select 'JSON format', :from => 'output_format'
    click_button 'Search'
    page.should have_content("\"org_number\":\"#{@attributes[:org_number]}\"")
  end

  # VCR not needed, since company is already created in database no remote lookup will take place
  it 'should return an xml result' do
    fill_in 'company_name', with: @attributes[:company_name]
    #noinspection RubyArgCount
    select 'XML format', :from => 'output_format'
    click_button 'Search'
    page.should have_content('556656-6880')
  end
end
