class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :search, Search
    cannot :manage, :profile
  end

  def admin_abilities
    can :manage, :all
    can :destroy, Comment
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can :me, User, id: user.id
    can :create, Vote do |vote|
      vote.votable.user_id != user.id
    end
    can :create, Subscription do |subscription|
      !subscription.question.subscribed_by?(user)
    end
    can :update, [Question,Answer], user_id: user.id
    can :set_best, Answer do |answer|
      answer.question.user_id == user.id
    end
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment do |att|
      att.attachmentable.user_id == user.id
    end
    can :destroy, Vote, user_id: user.id
    can :destroy, Subscription, user_id: user.id
  end


end
