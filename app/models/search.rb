class Search < ActiveRecord::Base
  require 'net/http'
  require 'uri'
  require 'nokogiri'
  require 'open-uri'

  # Searches db first for cache org. number if none is found Allabolag.se is searched
  # and if search yields results it is cached in db before returned to user
  def self.do_search(query)
    if query.blank?
      return []
    end
    results = []
    db_result = Search.find_by_company_name(query)
    if db_result.blank?
      results = parse_nokogiri(query)
		else
			results << db_result
    end
    results
  end


  # Searches Allabolag.se with Nokogiri
  def self.parse_nokogiri(query)
    uri = "http://www.allabolag.se/?what=#{query.gsub(' ','+')}"
    doc = Nokogiri::HTML(open(uri))
    a_hrefs = doc.css("td#hitlistName").css("a")

		hits = []
    a_hrefs.each do |link|
			if not link['title'].blank? and not link['href'].blank?
				doc = Nokogiri::HTML(open(link['href']))
				name = doc.css("span#printTitle").text
				org_nr = doc.css("span#printOrgnr").text
				if not org_nr.blank? and not name.blank?
					s = Search.new({:company_name => name, :org_number => org_nr})
					if not Search.exists?(company_name: s.company_name)
						s.save
					end
					hits << s
				end
      end
    end
		hits
  end
end
