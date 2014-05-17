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
		results = Search.where("company_name LIKE :prefix", prefix: "#{query}%")
    if results.empty?
      results = parse_nokogiri(query)
    end
    results
  end


  # Searches Allabolag.se with Nokogiri
  def self.parse_nokogiri(query)
    uri = "http://www.allabolag.se/?what=#{query.gsub(' ','+')}"
    doc = Nokogiri::HTML(open(uri))

		hits = []
		doc.css("div.hitlistRow tr td span").each do |a|
			if a.content =~ /Org\.nummer/i
				org_number_td = a.parent
				org_number_match = org_number_td.content.match (/\d{6}-\d{4}/)
			 	# We have found an org. number now find the matching name
				name_tr = org_number_td.parent.previous.previous
				name_ahref = name_tr.css("td#hitlistName").css("a")
				if (not name_ahref.empty?)
					name = name_ahref.attribute('title').content
					if not org_number_match.blank? and not name.blank?
						s = Search.new({ :company_name => name, :org_number => org_number_match[0] })
						# Avoid saving if we already have in cache
						if Search.exists?(company_name: s.company_name) or s.save
							hits << s
						end
					end
				end
			end
		end
		hits
  end
end
