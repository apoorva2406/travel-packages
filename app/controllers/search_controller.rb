class SearchController < ApplicationController

	def serach_by_type
    params[:search_office_type] = params[:types]
    @result = []
    @types_count = {}  
    temp = []
    if params[:ranges].present?
      ranges = params[:ranges].split(',')
      properties = Property.search "*", where: {id: params[:properties_ids], range: ranges[0]..ranges[1]}
      @types_count.merge!(type=> properties.count)
      properties.each{|p| @result << p}
		else
      params[:types].each do |type|
        properties = Property.search type, where: {id: params[:properties_ids]} 
        if properties.present?
          @types_count.merge!(type=> properties.count)
          properties.each{|p| @result << p} 
        end  
      end
    end
    @properties = @result

    respond_to do |format|
      format.js
    end
	end

end





