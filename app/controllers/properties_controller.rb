class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy, :create_step_2, :step_2]
  before_action :authenticate_user!,  only: [:new, :create, :update, :destroy, :edit, :step_2, :create_step_2]
  before_action :check_property_owner, only: [:edit, :step_2]
  load_and_authorize_resource

  def property_success;end
    
  def index
    #Search by desire location 
    desire_lat = Geocoder.coordinates(params[:desire_location])
    #Search by city
    city_lat  = Geocoder.coordinates(params[:search_city])
    
    #Search by peroperty type and city and desire location
    @result = []
    @types_count = {}
    if params[:search_office_type].present?
      params[:search_office_type].each do |type|
        #city present
        if desire_lat.present?
          properties = builder_query(desire_lat[0],desire_lat[1],type,"desire")
          properties = builder_query(city_lat[0],city_lat[1],type) if properties.blank?
        #desire location
        elsif city_lat.present?
          properties = search_indexed(desire_lat, city_lat, type)
        elsif params[:near_me].present? 
          lat = request.location.latitude.present? ? request.location.latitude : 20.5937
          lng = request.location.longitude.present? ? request.location.longitude : 78.9629
          properties = builder_query(lat,lng,type,"desire")
        else
          properties = Property.search type, where: {varified: true}
        end
        @types_count.merge!(type=> properties.count)
        properties.each{|p| @result << p}
      end
    else
      properties = Property.search "*", where: {varified: true}
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
      Property.search "#{type.present? ? type : "*"}", where: {varified: true, location: {near: {lat: lat, lon: lng}, within: "2mi"}} rescue []
    else
      Property.search "#{type.present? ? type : "*"}", where: {varified: true, location: {near: {lat: lat, lon: lng}}} rescue []
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
    #@property = Property.new(property_params)
    respond_to do |format|
      if @property.save
        #@property.create_user
        @property.add_type_access_day(params)
        #@property.add_images(params[:property][:images], params[:new_image])
        format.html { redirect_to step_2_property_path(@property) } ##property_success_path
        #format.json { render :show, status: :created, location: @property }
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
        #@property.add_images(params[:property][:images], params[:new_image])
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
      
      property_price = @property.property_prices.where(property_type_id: key.to_i).first
      if property_price.blank?
        p_p = @property.property_prices.create(
          seats: value['seats'].present? ? value['seats'] : nil, 
          price: value['price'],  
          monthly_price: value['monthly_price'],
          hourly_price: value['hourly_price'],
          basic_unit: value['basic_unit'],
          property_type_id: key
        )

        if value[:images].present?
          value[:images].each do |image|
            @property.photos.create(image: image[1], property_type_id: key)
          end
        end

        if value['number_of_room'].present?
          p_p.number_of_room = value['number_of_room']
          p_p.save
          value['room'].each do |key,value|
            p_p.childrens.create(seats: value)
          end 
        end
      else
        property_price.seats =  value['seats'].present? ? value['seats'] : nil 
        property_price.price = value['price']  
        property_price.monthly_price =  value['monthly_price']
        property_price.hourly_price =  value['hourly_price']
        property_price.basic_unit = value['basic_unit']
        property_price.property_type_id = key
        property_price.save   

        if value[:images].present?
          value[:images].each do |image|
           if @property.photos.where(property_type_id: key)[image[0].to_i]
              @property.photos.where(property_type_id: key)[image[0].to_i].update(image: image[1])
            else
              @property.photos.create(image: image[1], property_type_id: key)
            end
          end
        end

        if value['number_of_room'].present?
          PropertyPrice.where(parent_id: property_price.id).delete_all
          property_price.number_of_room = value['number_of_room']
          property_price.save
          value['room'].each do |key,value|
            property_price.childrens.create(seats: value)
          end 
        end
      end
    end
    redirect_to property_path(@property),notice: 'Thanks for regestering your property we will contact you soon'
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
      #num_id = Property.last.try(:id)
      #params[:property][:name] = num_id.present? ? "IVS Offices-#{num_id+1}" : "IVS Offices-1"
      params.require(:property).permit(:name, :phone_number, :email, :no_of_seats, :contact_person, :description, :address, :start_date,  :end_date, :user_id)
    end
end
