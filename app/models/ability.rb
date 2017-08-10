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
    can :destroy, Event
    can [:edit, :update], Event do |model|
      @user==model.owner
    end
    can :index, Dashboard
    # can :create, [Question, Answer, Comment]
    # can [:update, :destroy], [Question, Answer, Comment], user: user
    # can :accept, Answer do |answer|
    #   !answer.accept && @user.author_of?(answer.question) && !@user.author_of?(answer)
    # end
    # can [:vote_up, :vote_down], [Question, Answer] do |model|
    #   !@user.author_of?(model)
    # end
    # can :edit, [Question, Answer]
    # can :manage, Vote
    # can :manage, Attachment do |attach|
    #   @user.author_of?(attach.attachable)
    # end
    # can :manage, Authorization
    # can :create, Subscription
    # can :destroy, Subscription do |subscription|
    #   @user.author_of? subscription
    # end
  end

  def admin_abilities
    can :manage, :all
  end
end
