class SearchController < ApplicationController

	def serach_by_type
    params[:search_office_type] = params[:types]
    @result = []
    @types_count = {}  
    @facilities_count = {}
    if params[:types].present?
      ranges = params[:ranges].split(',') if params[:ranges].present?
      params[:types].each do |type|
        #With range
        if ranges.present?
          properties = Property.search type, where: {varified: true , id: params[:properties_ids], range: ranges[0].to_i..ranges[1].to_i} 
        #With nearest place
        elsif params[:location_by].eql?("nearest-loc") ||  params[:location_by].eql?("entered-loc")
          lat = request.try(:location).try(:latitude)
          lng = request.try(:location).try(:longitude)
          if params[:location_by].eql?("nearest-loc")
           properties =  Property.search type, where: {varified: true, id: params[:properties_ids], location: {near: {lat: lat, lon: lng}, within: "7mi"}}
          elsif params[:location_by].eql?("entered-loc")
            properties =  Property.search type, where: {varified: true, id: params[:properties_ids], location: {near: {lat: lat, lon: lng}, within: "7mi"}}
          end
        #With facility
        elsif params[:facilities].present?
          properties = Property.search type, where: {varified: true , id: params[:properties_ids], facilities: params[:facilities]} 
        else
          properties = Property.search type, where: {varified: true , id: params[:properties_ids]} 
        end
        
        #With rent_status
        if params[:rent_status].present?
          properties = Property.search type, where: {varified: true , id: params[:properties_ids], rent_status: params[:rent_status]} 
        end

        if properties.present?
          @types_count.merge!(type=> properties.count)
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





