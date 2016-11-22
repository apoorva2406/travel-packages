class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new 
    if user.has_role? :Admin
      can :manage, :all
    elsif user.has_role? :Owner
      can :manage, :all
    else
      can :read, Property
    end
  end
end
