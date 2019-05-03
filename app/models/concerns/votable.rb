module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  def vote(user,type)
    return if voted?(user)
    transaction do
      self.votes.create!(user: user, score: type ? 1 : -1)
    end
  end

  def cancel_vote(user)
    vote = self.votes.find_by(user: user)
    vote.destroy
  end

  def score
    votes.sum(:score)
  end
end
