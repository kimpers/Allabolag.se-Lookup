require 'spec_helper'

describe Search do
  before(:each) do
    @attributes = {:company_name => "Company AB", :org_number => "123456-4321"}
    @valid_company = {:company_name => 'Google Sweden AB', :org_number => '556656-6880'}
  end

  it 'should find apoex ab on allabolag' do
    s = Search.do_search(@valid_company[:company_name])
    s.org_number.should be_an_eql @valid_company[:org_number]

  end
  it 'should not find anything when searching for a non existing company' do
    s = Search.do_search('notavalidcompany')
    s.should be_blank
  end

  it 'should find an existing user with search method' do
    Search.create(@attributes)
    s = Search.do_search(@attributes[:company_name])
    s.should_not be_blank
  end

  it 'should create a new search' do
    Search.create!(@attributes)
  end

  it 'should find already created search' do
    Search.create(@attributes)
    Search.find_by_company_name(@attributes[:company_name]).should be_valid
  end

  it 'should not find non existing search' do
    Search.find_by_company_name("Fake company").should be_blank
  end


end
