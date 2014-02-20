require 'spec_helper'

describe Search do
  before(:each) do
    @attributes = {:query => "Company AB", :result => "CMP"}
  end
  it 'should create a new search' do
    Search.create!(@attributes)
  end

  it 'should find already created search' do
    Search.create(@attributes)
    Search.find_by_query(@attributes[:query]).should be_valid
  end

  it 'should not find non existing search' do
    Search.find_by_query("Fake company").should be_an_blank
end
end
