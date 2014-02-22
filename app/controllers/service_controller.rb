class ServiceController < ApplicationController
  def index
    @title = "Allabolag.se request service"
    @search = NIL
  end

  def results
    puts "in results method"
    @search = Search.do_search(params[:q])
    if not @search.blank?
      if (params[:output_format] == 'json')
        render :json  => @search
      elsif (params[:output_format] == 'xml')
        render :xml  => @search
      end
    end
  end

end
