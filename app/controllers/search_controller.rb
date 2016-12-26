class SearchController < ApplicationController

	def serach_by_type
    params[:search_office_type] = params[:types]
    @result = []
    @types_count = {}  
    @facilities_count = {}

    if params[:location_by].present?
      lat = request.try(:location).try(:latitude)
      lng = request.try(:location).try(:longitude)
      if params[:location_by].eql?("nearest-loc")
       properties =  Property.search "*", where: {varified: true, id: params[:properties_ids], location: {near: {lat: lat, lon: lng}, within: "7mi"}}
      elsif params[:location_by].eql?("entered-loc")
        properties =  Property.search "*", where: {varified: true, id: params[:properties_ids], location: {near: {lat: lat, lon: lng}, within: "7mi"}}
      end
      properties.each{|p| @result << p} if properties.present?
    end

    if params[:ranges].present?
      ranges = params[:ranges].split(',')
      properties = Property.search "*", where: {varified: true, id: params[:properties_ids], range: ranges[0]..ranges[1]}
      properties.each{|p| @result << p}
    end
  
    if params[:types].present?
      params[:types].each do |type|
        properties = Property.search type, where: {varified: true , id: params[:properties_ids]} 
        if properties.present?
          @types_count.merge!(type=> properties.count)
          properties.each{|p| @result << p} 
        end  
      end
    end

    if params[:facilities].present?
      params[:facilities].each do |facility|
        properties = Property.search facility, where: {varified: true, id: params[:properties_ids]} 
        if properties.present?
          @facilities_count.merge!(facility=> properties.count)
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





