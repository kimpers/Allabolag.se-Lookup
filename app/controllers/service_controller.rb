class ServiceController < ApplicationController
  def index
    @title = "Allabolag.se request service"
    @search = NIL
  end

  def search
    puts params[:q]
    @search = Search.find_by_query(params[:q])
    if @search.blank?
      puts "empty need to create"
      @search = Search.new
      @search.query = params[:q]
      @search.save
    else
      puts "found object"
    end

    redirect_to root_path
  end
end
