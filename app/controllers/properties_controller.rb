class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy, :create_step_2, :step_2]
  before_action :authenticate_user!,  only: [:create, :new, :update, :destroy, :edit, :step_2, :create_step_2]
  before_action :check_property_owner, only: [:edit, :step_2]
  load_and_authorize_resource
  
  def index
    #Search by desire location 
    desire_lat = Geocoder.coordinates(params[:desire_location])
    #Search by city
    city_lat  = Geocoder.coordinates(params[:search_city])
    
    #Search by peroperty type and city and desire location
    @result = []
    if params[:search_office_type].present?
      params[:search_office_type].each do |type|
        #city present
        if city_lat.present?
          properties = search_indexed(desire_lat, city_lat, type)
        #desire location
        elsif desire_lat.present?
          properties = builder_query(desire_lat[0],desire_lat[1],type,"desire")
          properties = builder_query(city_lat[0],city_lat[1],type) if properties.blank?
        else
          properties = Property.search type
        end
        properties.each{|p| @result << p}
      end

    #Search by city  
    elsif city_lat.present?
      properties = search_indexed(desire_lat, city_lat, '')
      properties.each{|p| @result << p}

    #Search by desire location   
    elsif desire_lat.present?
      properties = builder_query(desire_lat[0],desire_lat[1],'',"desire")
      properties.each{|p| @result << p}
    
    #near by me
    elsif params[:near_me].present? 
      lat = request.location.latitude.present? ? request.location.latitude : 20.5937
      lng = request.location.longitude.present? ? request.location.longitude : 78.9629
      properties = builder_query(lat,lng,'',"desire")
      properties.each{|p| @result << p}
    else
      properties = Property.search "*"
      properties.each{|p| @result << p}
    end

    @properties  = @result.uniq

  end

  def search_indexed(desire_lat, city_lat, type={})
    if desire_lat.present?
      properties = builder_query(desire_lat[0],desire_lat[1],type,"desire")
    else
      properties = builder_query(city_lat[0],city_lat[1],type)
    end
    properties
  end

  def builder_query(lat, lng, type={}, miles={})
    if miles.present?
      Property.search "#{type.present? ? type : "*"}", where: {location: {near: {lat: lat, lon: lng}, within: "2mi"}}
    else
      Property.search "#{type.present? ? type : "*"}", where: {location: {near: {lat: lat, lon: lng}}}
    end
  end

  def show
    @near_by_properties = Property.search "*", where: {location: {near: {lat: @property.latitude, lon: @property.longitude}, within: "3mi"}}
    unless current_user.present? && ((current_user.has_role? :Owner) && @property.user == current_user)
      redirect_to property_dashboard_path(@property)
    end
  end

  def new
    @property = Property.new
  end

  def edit
  end

  def create
    @property = current_user.properties.new(property_params)
    respond_to do |format|
      if @property.save
        @property.add_type_access_day(params)
        @property.add_images(params[:property][:images], params[:new_image])
        format.html { redirect_to step_2_property_path(@property), notice: 'Property was successfully created.' }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @property.update(property_params)
        @property.add_type_access_day(params)
        @property.add_images(params[:property][:images], params[:new_image])
        format.html { redirect_to step_2_property_path(@property), notice: 'Property was successfully updated.' }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def step_2
  end

  def create_step_2
    params[:price].each_with_index do |(key,value),index|
      property_price = @property.property_prices.where(property_type_id: key).first
      propert_type = @property.property_types.where(name: 'Meeting/Conference Room').first
      if property_price.present?
        if propert_type.id.eql?(key.to_i)
          create_property_meeting(property_price, params[:number_of_room], params[:room])
        else
          property_price.seats = params[:seats][key]
          property_price.price = value
          property_price.save
        end  
      else
        p_p = @property.property_prices.create(
          seats: params[:seats][key], 
          price: value,  
          property_type_id: key 
        )
        create_property_meeting(p_p, params[:number_of_room], params[:room]) if propert_type.id.eql?(key.to_i)
      end  
    end
    redirect_to property_path(@property),notice: 'Property seats and price successfully created'
  end

  def create_property_meeting(p_p, number_of_room, rooms)
    PropertyPrice.where(parent_id: p_p.id).delete_all
    p_p.number_of_room = number_of_room
    p_p.save
    rooms.each do |key,value|
      p_p.childrens.create(seats: value)
    end 
  end

  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url, notice: 'Property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_image
    photo = Photo.where(id: params[:photo_id]).first.delete
    render :nothing =>true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    def check_property_owner
      unless current_user.properties.include?(@property)
        redirect_to root_path, alert: "Access denied."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:name, :phone_number, :email, :no_of_seats, :contact_person, :description, :address, :start_date,  :end_date, :user_id)
    end
end
