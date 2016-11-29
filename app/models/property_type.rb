class PropertyType < ActiveRecord::Base
	has_many :property_type_manages
  has_many :properties, through: :property_type_manages
end
