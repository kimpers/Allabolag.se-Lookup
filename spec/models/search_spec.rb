require 'spec_helper'
require 'vcr_setup'

describe Search do
  before(:each) do
    @attributes = {:company_name => 'Company AB', :org_number => '123456-4321'}
    @valid_company = {:company_name => 'Google Sweden AB', :org_number => '556656-6880'}
		@google_companies = ['Google Sweden AB', 'GOOGLE COMMERCE LTD', 'GOOGLE COMMERCE LTD','GOOGLE INC.', 'GOOGLE IRELAND LTD']
  end

  it 'should find Google Sweden on allabolag' do
    VCR.use_cassette('google_search') do
      results = Search.do_search(@valid_company[:company_name])
			expect(results.find { |result| result[:org_number] == @valid_company[:org_number]})
    end
	end

	it 'should find all companies for Google' do
		VCR.use_cassette('all_google_companies_search)') do
			results = Search.do_search("google");
			@google_companies.each do |company|
				expect(results.find { |result| result[:company_name] == company})
			end
		end
	end


	it 'should find all companies for Google when results are cached' do
		VCR.use_cassette('all_google_companies_search)') do
			Search.do_search("google");
			results = Search.do_search("google");
			@google_companies.each do |company|
				expect(results.find { |result| result[:company_name] == company})
			end
		end
	end
	it "should find cached companies" do
		s = Search.create!(@valid_company)
		results = Search.do_search(@valid_company[:company_name])
		results.first.should be_eql(s)
	end
  it 'should not find anything when searching for a non existing company' do
    VCR.use_cassette('no_company_do_search') do
      s = Search.do_search('notavalidcompany')
      s.should be_blank
    end
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
    Search.find_by_company_name('Fake company').should be_blank
  end


end
