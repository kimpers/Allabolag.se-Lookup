require 'spec_helper'

describe 'Home page' do
  describe 'GET /' do
    it 'should load correctly' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
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
  it 'should return a correct value for existing company' do
    fill_in 'company_name', with: @attributes[:company_name]
    click_button 'Search'
    page.should have_content(@attributes[:org_number])
  end

  it 'should return no results for a not in either database or on allabolag.se company' do
    fill_in 'company_name', with: 'qwertyuiop'
    click_button 'Search'
    page.should have_content('No results')
  end

  it 'should return an json result' do
    fill_in 'company_name', with: @attributes[:company_name]
    #noinspection RubyArgCount
    select 'JSON format', :from => 'output_format'
    click_button 'Search'
    page.should have_content("\"org_number\":\"#{@attributes[:org_number]}\"")
  end

  it 'should return an xml result' do
    fill_in 'company_name', with: @attributes[:company_name]
    #noinspection RubyArgCount
    select 'XML format', :from => 'output_format'
    click_button 'Search'
    page.should have_content('556656-6880')
  end
end
