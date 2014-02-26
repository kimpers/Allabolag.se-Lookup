class ServiceController < ApplicationController
  def index
    @title = 'Allabolag.se Lookup'
  end

  def results
    @search = Search.do_search(params[:company_name])

    if (params[:output_format] == 'json')
      if @search.blank?
        @search = Search.new
        @search.company_name = ''
        @search.org_number =''
      end
      render :json => @search, :except => [:id, :created_at, :updated_at]
    elsif (params[:output_format] == 'xml')
      if @search.blank?
        @search = Search.new
        @search.company_name = ''
        @search.org_number =''
      end
      render :xml => @search, :except => [:id, :created_at, :updated_at]
    end
  end

end
