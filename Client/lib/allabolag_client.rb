class AllabolagClient
  require 'net/http'
  require 'uri'
  require 'json'
  def initialize(server_url)
    @url = server_url
  end

  # Searches with a GET request to service, parses response as JSON.
  # If response is not a valid JSON then search did not return any results
  def search(name)
    uri = URI.parse(@url + "/results?&company_name=#{name.gsub(' ','+')}&output_format=json")
    response = Net::HTTP.get_response(uri)
    begin
      parsed_response = JSON.parse(response.body)
    rescue JSON::ParserError
      return 'no results'
    else
      return parsed_response
    end
  end
end

if __FILE__ == $0
  name = ''
  $*.each { |x| name << x + ' ' }
  name.strip!
  c = AllabolagClient.new('http://localhost:3000')
  results = c.search(name)
	if results.empty?
		puts 'no results'
	else
		results.each do |result|
			puts result["company_name"] + " " + result["org_number"]
		end
	end
end
