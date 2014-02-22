class ServiceController < ApplicationController
  def index
    @title = "Allabolag.se request service"
    @search = NIL
  end

  def results
    puts "in results method"
    @search = Search.do_search(params[:q])
    if @search.blank?
      puts "empty need to do search"
    else
      puts "found object"

    end

  end
end
