# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :vote_up, :vote_down, :vote_cancel, to: :vote

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
    can :create, :all
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:create], Subscription
    can [:destroy], Subscription, { user_id: user.id }

    can :vote, [Question, Answer] do |object|
      !user.author_of?(object)
    end
    can :best, Answer, question: { user_id: user.id }
  end

  def admin_abilities
    can :manage, :all
  end
end
