class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:subscribable_type, :subscribable_id] }
end
