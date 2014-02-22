class Search < ActiveRecord::Base
  def self.do_search(query)
    results = Search.find_by_query(query)
    if results.blank?
      puts "empty need to do search"



    end
    return results
  end
end
