class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, Event
    can :view, Event do |model|
      !(@user.owner?(model) || model.viewed?(@user))
    end
    can [:edit, :update, :destroy, :share], Event do |model|
      @user.owner?(model)
    end
    can :index, Dashboard
  end

  def admin_abilities
    can :manage, :all
  end
end
