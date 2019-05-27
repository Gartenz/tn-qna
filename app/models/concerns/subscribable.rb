module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscribe(user)
    transaction do
      if !subscribed? user
        self.subscriptions.create!(user: user)
      else
        subscriptions.find_by(user: user).destroy
      end
    end
  end
end
