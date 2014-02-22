require 'spec_helper'

describe Search do
  before(:each) do
    @attributes = {:query => "Company AB", :result => "CMP"}
    @apoex = {:query => 'Apoex ab', :result => '556633-4149'}
  end

  it 'should find apoex ab on allabolag' do
    s = Search.do_search(@apoex[:query])
    s.result.should be_an_eql @apoex[:result]

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
