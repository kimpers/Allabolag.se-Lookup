class Search < ActiveRecord::Base
  require 'net/http'
  require 'uri'
  require 'nokogiri'
  require 'open-uri'

  # Searches db first for cache org. number if none is found Allabolag.se is searched
  # and if search yields results it is cached in db before returned to user
  def self.do_search(query)
    if query.blank?
      return NIL
    end
    results = Search.find_by_company_name(query)
    if results.blank?
      search_results = parse_nokogiri(query)
      if not search_results.blank?
        results = Search.new
        results.company_name = search_results[:name]
        results.org_number = search_results[:org_number]
        results.save
      end
    end
    return results
  end


  # Searches Allabolag.se with Nokogiri
  def self.parse_nokogiri(query)
    uri = "http://www.allabolag.se/?what=#{query.gsub(' ','+')}"
    doc = Nokogiri::HTML(open(uri))
    a_hrefs = doc.css("td#hitlistName").css("a")

# Do case insensitive regex matching because we want CoMPAny to match Company etc
# And we don't want to rely on first match always being the correct one
    title = NIL
    url = NIL
    a_hrefs.each do |link|
      if link['title'] =~ /#{query}/i
        title = link['title']
        url = link['href']
      end
    end

    if title.nil? || url.nil?
      return NIL
    end

    doc = Nokogiri::HTML(open(url))
    org_nr = doc.css("span#printOrgnr").text

    return {:name => title, :org_number => org_nr}
  end
end
