class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy, :create_step_2, :step_2]
  before_action :authenticate_user!,  only: [:create, :new, :update, :destroy, :edit, :step_2, :create_step_2]
  before_action :check_property_owner, only: [:edit, :step_2]
  load_and_authorize_resource
  
  def index
    if params[:near_me].eql?("true")
      @properties = Property.near(request.location.address.eql?('Reserved') ? "Indore" : request.location.address )
    elsif params[:desire_location].present?
      @properties = Property.search params[:desire_location]
    else
      @properties = Property.search "*"
    end
  end

  def show
    unless current_user.present? && (current_user.has_role? :Owner)
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
    params[:seats].each_with_index do |(key,value),index|
      property_price = @property.property_prices.where(property_type_id: key).first
      if property_price.present?
        property_price.seats = value
        property_price.price = params[:price][key]
        property_price.save
      else
        @property.property_prices.create(
          seats: value, 
          price: params[:price][key],  
          property_type_id: key 
        )
      end  
    end
    redirect_to property_path(@property),notice: 'Property seats and price successfully created'
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
        redirect_to root_path, alert: "You don't have rights to edit this property"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:name, :phone_number, :email, :no_of_seats, :contact_person, :address, :start_date,  :end_date, :user_id)
    end
end
