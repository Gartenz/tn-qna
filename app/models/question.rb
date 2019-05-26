class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscribable

  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def mark_best(answer)
    if answers.include?(answer)
      old_best = best_answer
      return if old_best&.id == answer.id

      transaction do
        old_best&.update!(best: false)
        answer.update!(best: true)
        answer.question.reward&.update(user: answer.user)
      end
    end
  end
end
