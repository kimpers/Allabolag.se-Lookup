class Search < ActiveRecord::Base
  require "net/http"
  require "uri"

  def self.do_search(query)
    if query.blank?
      return NIL
    end
    results = Search.find_by_company_name(query)
    if results.blank?
      search_results = parse_website(query);
      if not search_results.blank?
        results = Search.new
        results.company_name = search_results[:name]
        results.org_number = search_results[:org_number]
        results.save
      end
    end
    return results
  end


  def self.parse_website(query)
    uri = URI.parse('http://www.allabolag.se')
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get('/?what=' + query.gsub(' ','+'))
    if response.body.blank?
      return NIL
    end
    # Get url to company sub page so information can be safely extracted without too complicated regexp
    url = response.body[/(?<=<a href=).+(?=title="#{query}")/i]
    if url.blank?
      return NIL
    end
    url = url.gsub('"', '')
    response = Net::HTTP.get_response(URI.parse(url))
    name_correct_capitalization = response.body[/#{query}/i]
    org_number_row = response.body[/(?<=ORG\.NR).+/i]
    org_number = org_number_row[/\d{6}-\d{4}/]
    # Make sure we don't get any semi parsed results
    if name_correct_capitalization.blank? || org_number.blank?
      return NIL
    end
    return {:name=> name_correct_capitalization, :org_number => org_number}
  end
end
