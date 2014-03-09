require "rubygems"
require "allabolag_client"
require "test/unit"
require "shoulda"
class ClientTest < Test::Unit::TestCase
  context "AllabolagClient" do
    should "return correct value when searching for a valid company" do
      client = AllabolagClient.new('http://localhost:3000')
      org_number = client.search('Google Sweden AB')
      assert_equal '556656-6880', org_number
    end
    should "return no results when searching for an invalid company" do
      client = AllabolagClient.new('http://localhost:3000')
      org_number = client.search('notavalidcompany')
      assert_equal 'no results', org_number
    end

    should "return no results when providing an empty query" do
      client = AllabolagClient.new('http://localhost:3000')
      org_number = client.search('')
      assert_equal 'no results', org_number
    end
  end
end