class SearchController < ApplicationController

	def serach_by_type
    @result = []
    if params[:ranges].present?
      ranges = params[:ranges].split(',')
      properties = Property.search "*", where: {id: params[:properties_ids], range: ranges[0]..ranges[1]}
      properties.each{|p| @result << p}
		else
      params[:types].each do |type|
        properties = Property.search type, where: {id: params[:properties_ids]} 
        if properties.present?
          properties.each{|p| @result << p} 
        end  
      end
    end
    @properties = @result.uniq

    respond_to do |format|
      format.js
    end
	end

end





