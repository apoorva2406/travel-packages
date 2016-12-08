class PropertyPrice < ActiveRecord::Base
	belongs_to :property
	belongs_to :parent, :class_name => 'PropertyPrice'
	has_many :childrens, :class_name => 'PropertyPrice', :foreign_key => :parent_id
end
