class ServiceController < ApplicationController
  def index
    @title = "Allabolag.se request service"
    @search = NIL
  end

  def results
    @search = Search.do_search(params[:company_name])
    if not @search.blank?
      if (params[:output_format] == 'json')
        render :json  => @search, :except => [:id, :created_at, :updated_at]
      elsif (params[:output_format] == 'xml')
        render :xml  => @search, :except => [:id, :created_at, :updated_at]
      end
    end
  end

end
