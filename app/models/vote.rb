class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :good, inclusion: { in: [ true, false ] }
  validate :uniqness

  scope :good, -> { where(good: true) }
  scope :bad, -> { where(good: false) }

private

  def uniqness
    unless Vote.find_by(votable: self.votable, user: self.user).nil?
      self.errors.add([:votable, :user], 'User can not vote again')
    end
  end
end
