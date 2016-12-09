class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 	has_one :authentication
  has_many :properties
  has_many :bookings

  def apply_omniauth(omniauth)
    self.profile_image = omniauth['info']['image']
	  self.email = omniauth['info']['email']
	  self.name = omniauth['info']['name']
	  case omniauth['provider']
	  when 'facebook'
	   when 'google_oauth2'
	  end
	end

  def update_omniauth(omniauth)
    self.profile_image = omniauth['info']['image']
    self.save
  end

  def assign_user_role(role)
    self.add_role(role) if self.roles.blank?
  end

  def client?
    self.has_role? :Client    
  end

  def owner?
    self.has_role? :Owner
  end

  def check_user_access?
    ( self.owner? ? true : false)
  end
end
