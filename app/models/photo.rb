class Photo < ActiveRecord::Base
	belongs_to :imageable, :polymorphic => true
	has_attached_file :image, styles: { medium: "500x500>", thumb: "300x300>" }
  	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
