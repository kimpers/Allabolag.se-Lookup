class Client
  require 'net/http'
  require 'uri'
  require 'json'
  def initialize(server_url)
    @url = server_url
  end

  def search(name)
    uri = URI.parse(@url + "/results?&company_name=#{name.gsub(' ','+')}&output_format=json")
    response = Net::HTTP.get_response(uri)
    begin
      parsed_response = JSON.parse(response.body)
    rescue JSON::ParserError
      return 'no results'
    else
      return parsed_response['org_number']
    end
  end
end

if __FILE__ == $0
  name = ''
  $*.each { |x| name << x + ' ' }
  name.strip!
  c = Client.new('http://localhost:3000')
  puts c.search(name)
end