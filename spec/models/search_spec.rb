require 'spec_helper'

describe Search do
  before(:each) do
    @attributes = {:company_name => "Company AB", :org_number => "CMP"}
    @apoex = {:company_name => 'Apoex ab', :org_number => '556633-4149'}
  end

  it 'should find apoex ab on allabolag' do
    s = Search.do_search(@apoex[:company_name])
    s.org_number.should be_an_eql @apoex[:org_number]

  end

  it 'should find an existing user with search method' do
    Search.create(@attributes)
    s = Search.do_search(@attributes[:company_name])
    s.should_not be_blank
  end
  it 'should create a non existing search by parsing website' do
    pending "Fix this"
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
