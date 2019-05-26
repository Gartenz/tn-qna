module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscribers, as: :subscribable, dependent: :destroy,  class_name: "Subscription"
  end

  def subscribed?(user)
    subscribers.exists?(user: user)
  end

  def subscribe(user)
    transaction do
      if !subscribed? user
        self.subscribers.create!(user: user)
      else
        subscribers.find_by(user: user).destroy
      end
    end
  end
end
