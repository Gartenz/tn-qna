module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user

    after_create :subscribe_author
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscribe(user)
    if !subscribed?(user)
      self.subscriptions.create!(user: user)
    end
  end

  private

  def subscribe_author
    self.subscribe(user)
  end
end
