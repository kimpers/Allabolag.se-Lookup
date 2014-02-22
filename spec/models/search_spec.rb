require 'spec_helper'

describe Search do
  before(:each) do
    @attributes = {:query => "Company AB", :result => "CMP"}
  end
  it 'should find an existing user with search method' do
    Search.create(@attributes)
    s = Search.do_search(@attributes[:query])
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
    Search.find_by_query(@attributes[:query]).should be_valid
  end

  it 'should not find non existing search' do
    Search.find_by_query("Fake company").should be_blank
end
end
